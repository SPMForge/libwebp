#!/usr/bin/env python3

from __future__ import annotations

import argparse
import dataclasses
import json
import os
import posixpath
import plistlib
import re
import shutil
import stat
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path


if sys.version_info < (3, 10):
    raise SystemExit("spm_release.py requires Python 3.10 or newer.")


SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from spm_release_support.package_validation import (
    render_local_binary_package_swift,
    render_package_swift,
    render_spm_consumer_package_swift,
    render_spm_consumer_sources,
    swift_string_literal,
    validate_checksums_payload,
)
from spm_release_support.platform_contract import (
    ARTIFACT_DEFINITIONS,
    ArtifactDefinition,
    CMAKE_CONFIGURATION_ARGS,
    CompilerWrapperPaths,
    PlatformGroup,
    BuiltSlice,
    PLATFORM_GROUPS,
    deployment_target_version,
    artifact_definition_by_name,
    build_plan_payload,
    swiftpm_product_targets,
)
from spm_release_support.release_planning import (
    latest_package_release_tag_for_upstream_tag,
    next_package_release_tag_for_upstream_tag,
    package_release_tag_for_upstream_tag,
    package_release_tags_for_upstream_tag,
    plan_release_publication,
    release_artifacts_for_tag,
    require_package_distribution_tag,
    require_package_release_tag,
    require_stable_tag,
    required_release_asset_names,
    select_latest_stable_tag,
    resolve_release_publication,
)

QUOTED_INCLUDE_PATTERN = re.compile(
    r'^(?P<prefix>\s*#\s*(?:include|import)\s*)"(?P<target>[^"]+)"(?P<suffix>.*)$'
)
REPO_ROOT = Path(__file__).resolve().parents[1]
SOURCE_ACQUISITION_CONFIG_PATH = REPO_ROOT / "config" / "source-acquisition.json"
GITHUB_NOT_FOUND_MARKERS = ("HTTP 404", "not found")


@dataclasses.dataclass(frozen=True)
class SourceAcquisitionConfig:
    strategy: str
    upstream_repository_url: str
    upstream_tag_namespace: str
    upstream_tag_refspec: str
    source_snapshot_directory: str

    def upstream_ref_for_tag(self, tag: str) -> str:
        require_stable_tag(tag)
        return f"{self.upstream_tag_namespace}/{tag}"


@dataclasses.dataclass(frozen=True)
class GitHubReleaseState:
    release_exists: bool
    release_is_prerelease: bool
    release_is_latest: bool
    release_asset_names: tuple[str, ...]
    release_id: int | None


@dataclasses.dataclass(frozen=True)
class PreparedReleasePublication:
    final_package_tag: str
    mode: str
    required_assets: tuple[str, ...]
    missing_assets: tuple[str, ...]
    metadata_needs_repair: bool
    release_exists: bool
    remote_tag_exists: bool
    remote_tag_commit: str | None
    release_id: int | None
    release_is_prerelease: bool
    release_is_latest: bool


def load_source_acquisition_config(path: Path = SOURCE_ACQUISITION_CONFIG_PATH) -> SourceAcquisitionConfig:
    raw_config = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(raw_config, dict):
        raise ValueError("Source acquisition config must be a JSON object.")

    strategy = str(raw_config.get("strategy", "")).strip()
    upstream_repository_url = str(raw_config.get("upstream_repository_url", "")).strip()
    upstream_tag_namespace = str(raw_config.get("upstream_tag_namespace", "")).strip()
    upstream_tag_refspec = str(raw_config.get("upstream_tag_refspec", "")).strip()
    source_snapshot_directory = str(raw_config.get("source_snapshot_directory", "")).strip()

    if strategy != "git-tag-export":
        raise ValueError("Unsupported source acquisition strategy. Expected git-tag-export.")
    if not upstream_repository_url:
        raise ValueError("Source acquisition config is missing upstream_repository_url.")
    if not upstream_tag_namespace.startswith("refs/"):
        raise ValueError("Source acquisition config upstream_tag_namespace must start with refs/.")
    if not upstream_tag_refspec.startswith("refs/tags/") or ":" not in upstream_tag_refspec:
        raise ValueError(
            "Source acquisition config upstream_tag_refspec must map refs/tags/* into a dedicated namespace."
        )
    if not source_snapshot_directory:
        raise ValueError("Source acquisition config is missing source_snapshot_directory.")

    return SourceAcquisitionConfig(
        strategy=strategy,
        upstream_repository_url=upstream_repository_url,
        upstream_tag_namespace=upstream_tag_namespace,
        upstream_tag_refspec=upstream_tag_refspec,
        source_snapshot_directory=source_snapshot_directory,
    )


def read_tags_from_cli_or_stdin(tags: list[str]) -> list[str]:
    if tags:
        return tags
    return [line.strip() for line in sys.stdin if line.strip()]


def fetch_upstream_tags(
    remote_name: str,
    config: SourceAcquisitionConfig | None = None,
) -> None:
    config = config or load_source_acquisition_config()

    try:
        command_output(["git", "remote", "get-url", remote_name])
        run_command(["git", "remote", "set-url", remote_name, config.upstream_repository_url])
    except RuntimeError:
        run_command(["git", "remote", "add", remote_name, config.upstream_repository_url])

    run_command(["git", "fetch", "--no-tags", "--force", remote_name, config.upstream_tag_refspec])


def latest_fetched_upstream_stable_tag(config: SourceAcquisitionConfig | None = None) -> str:
    config = config or load_source_acquisition_config()
    tags_output = command_output(
        ["git", "for-each-ref", "--format=%(refname:lstrip=2)", config.upstream_tag_namespace]
    )
    tags = [line.strip() for line in tags_output.splitlines() if line.strip()]
    return select_latest_stable_tag(tags)


def export_upstream_source_tree(
    tag: str,
    output_dir: Path,
    config: SourceAcquisitionConfig | None = None,
) -> Path:
    config = config or load_source_acquisition_config()
    require_stable_tag(tag)
    output_dir = output_dir.resolve()
    output_dir.parent.mkdir(parents=True, exist_ok=True)
    archive_path = output_dir.parent / f".{tag}.tar"

    if output_dir.exists():
        shutil.rmtree(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    upstream_ref = config.upstream_ref_for_tag(tag)
    command_output(["git", "rev-parse", "--verify", "--quiet", f"{upstream_ref}^{{commit}}"])
    try:
        run_command(
            [
                "git",
                "archive",
                "--format=tar",
                "--output",
                str(archive_path),
                upstream_ref,
            ]
        )
        run_command(["tar", "-xf", str(archive_path), "-C", str(output_dir)])
    finally:
        if archive_path.exists():
            archive_path.unlink()

    return output_dir


def ensure_command_exists(command: str) -> None:
    if shutil.which(command) is None:
        raise RuntimeError(f"Required command not found in PATH: {command}")


def run_command(
    args: list[str],
    *,
    cwd: Path | None = None,
    capture_output: bool = False,
) -> subprocess.CompletedProcess[str]:
    result = subprocess.run(
        args,
        cwd=str(cwd) if cwd is not None else None,
        check=False,
        capture_output=capture_output,
        text=True,
    )
    if result.returncode != 0:
        stdout = result.stdout.strip() if result.stdout else ""
        stderr = result.stderr.strip() if result.stderr else ""
        details = "\n".join(segment for segment in (stdout, stderr) if segment)
        raise RuntimeError(
            f"Command failed with exit code {result.returncode}: {' '.join(args)}"
            + (f"\n{details}" if details else "")
        )
    return result


def command_output(args: list[str], *, cwd: Path | None = None) -> str:
    return run_command(args, cwd=cwd, capture_output=True).stdout.strip()


def ensure_build_prerequisites() -> None:
    for command in ("cmake", "xcodebuild", "xcrun", "swift", "plutil", "otool", "install_name_tool"):
        ensure_command_exists(command)
    for group in PLATFORM_GROUPS:
        command_output(["xcrun", "--sdk", group.sdk, "--show-sdk-path"])
    command_output(["xcrun", "--find", "vtool"])


def ensure_source_tree_is_buildable(source_dir: Path) -> None:
    if not (source_dir / "CMakeLists.txt").exists():
        raise RuntimeError(f"Missing CMakeLists.txt in source tree: {source_dir}")


def copy_source_tree(source_dir: Path, destination_dir: Path) -> Path:
    ignored_names = shutil.ignore_patterns(
        ".git",
        ".github",
        "__pycache__",
        ".DS_Store",
        "build",
        "dist",
        "xcframeworkbuild",
    )
    working_source = destination_dir / "source"
    if working_source.exists():
        shutil.rmtree(working_source)
    shutil.copytree(source_dir, working_source, ignore=ignored_names)
    return working_source


def write_ccache_compiler_wrapper(path: Path, compiler_name: str) -> Path:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        "#!/bin/sh\n"
        f'exec ccache "$(xcrun --find {compiler_name})" "$@"\n',
        encoding="utf-8",
    )
    path.chmod(0o755)
    return path


def create_xcode_ccache_wrappers(directory: Path) -> CompilerWrapperPaths:
    return CompilerWrapperPaths(
        cc=write_ccache_compiler_wrapper(directory / "ccache-clang", "clang"),
        cxx=write_ccache_compiler_wrapper(directory / "ccache-clang++", "clang++"),
    )


def should_use_ccache() -> bool:
    return os.environ.get("SPM_RELEASE_ENABLE_CCACHE", "").lower() in {
        "1",
        "true",
        "yes",
        "on",
    }


def cmake_configuration_args_for_platform_group(
    platform_group: PlatformGroup,
    *,
    compiler_wrappers: CompilerWrapperPaths | None = None,
) -> tuple[str, ...]:
    # The Xcode generator needs the target architectures at configure time.
    # Passing only ARCHS during archive can produce object library references
    # that point at the wrong architecture directory in universal builds.
    arguments = [
        *CMAKE_CONFIGURATION_ARGS,
        f"-DCMAKE_OSX_ARCHITECTURES={platform_group.cmake_architectures}",
        f"-DCMAKE_OSX_SYSROOT={platform_group.sdk}",
        f"-DCMAKE_OSX_DEPLOYMENT_TARGET={platform_group.minimum_version}",
        "-DCMAKE_XCODE_ATTRIBUTE_SUPPORTS_MACCATALYST="
        + ("YES" if platform_group.catalyst else "NO"),
    ]
    if platform_group.cmake_system_name is not None:
        arguments.append(f"-DCMAKE_SYSTEM_NAME={platform_group.cmake_system_name}")
    if compiler_wrappers is not None:
        arguments.extend(
            [
                f"-DCMAKE_XCODE_ATTRIBUTE_CC={compiler_wrappers.cc}",
                f"-DCMAKE_XCODE_ATTRIBUTE_CXX={compiler_wrappers.cxx}",
            ]
        )
    return tuple(arguments)


def configure_cmake_project(
    source_dir: Path,
    build_dir: Path,
    *,
    platform_group: PlatformGroup,
) -> Path:
    build_dir.mkdir(parents=True, exist_ok=True)
    compiler_wrappers = None
    if should_use_ccache():
        if shutil.which("ccache") is None:
            raise RuntimeError(
                "SPM_RELEASE_ENABLE_CCACHE is set but ccache is not available in PATH."
            )
        compiler_wrappers = create_xcode_ccache_wrappers(build_dir / "compiler-wrappers")
    run_command(
        [
            "cmake",
            "-S",
            str(source_dir),
            "-B",
            str(build_dir),
            "-G",
            "Xcode",
            *cmake_configuration_args_for_platform_group(
                platform_group,
                compiler_wrappers=compiler_wrappers,
            ),
        ]
    )

    project_paths = sorted(build_dir.glob("*.xcodeproj"))
    if len(project_paths) != 1:
        raise RuntimeError(
            f"Expected exactly one generated Xcode project in {build_dir}, found {len(project_paths)}"
        )
    return project_paths[0]


def header_include_path(target_name: str, relative_path: str) -> Path:
    source_path = Path(relative_path)
    if source_path.parts and source_path.parts[0] == "src":
        source_path = Path(*source_path.parts[1:])
    return source_path


def normalize_header_reference(path: str) -> str:
    return posixpath.normpath(path.replace("\\", "/"))


def exported_header_include_paths(target_name: str) -> set[str]:
    definition = artifact_definition_by_name(target_name)
    return {
        header_include_path(definition.target_name, relative_path).as_posix()
        for relative_path in definition.public_headers
    }


def resolve_same_framework_header_include(
    target_name: str,
    current_header_path: Path,
    include_target: str,
) -> str | None:
    exported_paths = exported_header_include_paths(target_name)
    normalized_exact = normalize_header_reference(include_target)
    if normalized_exact in exported_paths:
        return normalized_exact

    normalized_relative = normalize_header_reference(
        posixpath.join(current_header_path.parent.as_posix(), include_target)
    )
    if normalized_relative in exported_paths:
        return normalized_relative
    return None


def rewrite_public_header_text(target_name: str, relative_path: str, contents: str) -> str:
    current_header_path = header_include_path(target_name, relative_path)
    rewritten_lines: list[str] = []
    for raw_line in contents.splitlines(keepends=True):
        line = raw_line.rstrip("\r\n")
        newline = raw_line[len(line) :]
        match = QUOTED_INCLUDE_PATTERN.match(line)
        if match is None:
            rewritten_lines.append(raw_line)
            continue

        rewritten_target = resolve_same_framework_header_include(
            target_name,
            current_header_path,
            match.group("target"),
        )
        if rewritten_target is None:
            rewritten_lines.append(raw_line)
            continue

        rewritten_lines.append(
            match.group("prefix")
            + f"<{target_name}/{rewritten_target}>"
            + match.group("suffix")
            + newline
        )
    return "".join(rewritten_lines)


def prepare_header_directories(source_dir: Path, output_root: Path) -> dict[str, Path]:
    header_paths: dict[str, Path] = {}
    for definition in ARTIFACT_DEFINITIONS:
        header_dir = output_root / definition.target_name
        header_dir.mkdir(parents=True, exist_ok=True)
        for relative_path in definition.public_headers:
            source_header = source_dir / relative_path
            if not source_header.exists():
                raise RuntimeError(
                    f"Missing public header for {definition.target_name}: {source_header}"
                )
            include_path = header_include_path(definition.target_name, relative_path)
            destination = header_dir / include_path
            destination.parent.mkdir(parents=True, exist_ok=True)
            destination.write_text(
                rewrite_public_header_text(
                    definition.target_name,
                    relative_path,
                    source_header.read_text(encoding="utf-8"),
                ),
                encoding="utf-8",
            )
        header_paths[definition.target_name] = header_dir
    return header_paths


def find_single_path(root: Path, pattern: str) -> Path:
    matches = sorted(root.rglob(pattern))
    if len(matches) != 1:
        raise RuntimeError(
            f"Expected exactly one match for {pattern} under {root}, found {len(matches)}"
        )
    return matches[0]


def find_built_dynamic_library(root: Path, library_name: str) -> Path:
    library_stem = library_name.removesuffix(".dylib")
    matches = sorted(path for path in root.rglob(f"{library_stem}*.dylib") if path.is_file())
    if not matches:
        raise RuntimeError(f"Unable to locate built dynamic library {library_name} under {root}")

    concrete_files = [path for path in matches if not path.is_symlink()]
    candidates = concrete_files or matches
    candidates.sort(key=lambda path: (len(path.name), path.name), reverse=True)
    return candidates[0]


def destination_probe_tokens(platform_group: PlatformGroup) -> tuple[str, ...]:
    if platform_group.catalyst:
        return ("platform:macOS", "variant:Mac Catalyst")
    return (f"platform:{platform_group.name}",)


def xcode_download_platform_name(platform_group: PlatformGroup) -> str | None:
    if platform_group.catalyst or platform_group.identifier == "macos":
        return None
    if platform_group.identifier.startswith("visionos"):
        return "visionOS"
    return platform_group.name.removesuffix(" Simulator")


def assert_destination_available(
    *,
    project_path: Path,
    scheme: str,
    platform_group: PlatformGroup,
) -> None:
    if platform_group.destination is None:
        return

    output = command_output(
        [
            "xcodebuild",
            "-project",
            str(project_path),
            "-scheme",
            scheme,
            "-showdestinations",
        ]
    )
    for raw_line in output.splitlines():
        line = raw_line.strip()
        if not line.startswith("{"):
            continue
        if not all(token in line for token in destination_probe_tokens(platform_group)):
            continue
        if "error:" in line:
            download_platform = xcode_download_platform_name(platform_group)
            guidance = ""
            if download_platform is not None:
                guidance = (
                    " Install the missing platform with "
                    + f"`xcodebuild -downloadPlatform {download_platform}`"
                    + " or from Xcode > Settings > Components."
                )
            raise RuntimeError(
                "Requested destination "
                + f"{platform_group.destination} is unavailable for scheme {scheme}: {line}"
                + guidance
            )
        return

    raise RuntimeError(
        "Requested destination "
        + f"{platform_group.destination} was not reported by xcodebuild -showdestinations for scheme {scheme}"
    )


def build_archive_for_slice(
    *,
    project_path: Path,
    artifact_definition: ArtifactDefinition,
    platform_group: PlatformGroup,
    archives_root: Path,
) -> BuiltSlice:
    archive_path = archives_root / artifact_definition.target_name / f"{platform_group.identifier}.xcarchive"
    derived_data_path = (
        archives_root / "derived-data" / artifact_definition.target_name / platform_group.identifier
    )
    archive_path.parent.mkdir(parents=True, exist_ok=True)
    derived_data_path.parent.mkdir(parents=True, exist_ok=True)

    arguments = [
        "xcodebuild",
        "-project",
        str(project_path),
        "-scheme",
        artifact_definition.cmake_target,
        "-configuration",
        "Release",
        "-derivedDataPath",
        str(derived_data_path),
        "-archivePath",
        str(archive_path),
        "archive",
    ]
    if platform_group.destination is not None:
        arguments.extend(["-destination", platform_group.destination])
    arguments.extend(platform_group.build_settings())
    assert_destination_available(
        project_path=project_path,
        scheme=artifact_definition.cmake_target,
        platform_group=platform_group,
    )
    run_command(arguments)

    binary_path = find_built_dynamic_library(derived_data_path, artifact_definition.library_name)
    validate_binary_platform(binary_path, platform_group.expected_vtool_platform)
    return BuiltSlice(
        platform_group=platform_group,
        archive_path=archive_path,
        binary_path=binary_path,
    )


def build_archived_libraries(
    *,
    source_dir: Path,
    build_root: Path,
    archives_root: Path,
) -> dict[str, list[BuiltSlice]]:
    build_output: dict[str, list[BuiltSlice]] = {
        definition.target_name: [] for definition in ARTIFACT_DEFINITIONS
    }
    for group in PLATFORM_GROUPS:
        project_path = configure_cmake_project(
            source_dir,
            build_root / group.identifier,
            platform_group=group,
        )
        for definition in ARTIFACT_DEFINITIONS:
            build_output[definition.target_name].append(
                build_archive_for_slice(
                    project_path=project_path,
                    artifact_definition=definition,
                    platform_group=group,
                    archives_root=archives_root,
                )
            )
    return build_output


def framework_binary_name(target_name: str) -> str:
    return target_name


def is_versioned_macos_framework(platform_group: PlatformGroup) -> bool:
    return platform_group.supported_platform == "macos"


def framework_binary_relative_path(target_name: str, platform_group: PlatformGroup) -> Path:
    binary_name = framework_binary_name(target_name)
    if is_versioned_macos_framework(platform_group):
        return Path("Versions") / "A" / binary_name
    return Path(binary_name)


def framework_resources_relative_dir(platform_group: PlatformGroup) -> Path:
    if is_versioned_macos_framework(platform_group):
        return Path("Versions") / "A" / "Resources"
    return Path()


def framework_headers_relative_dir(platform_group: PlatformGroup) -> Path:
    if is_versioned_macos_framework(platform_group):
        return Path("Versions") / "A" / "Headers"
    return Path("Headers")


def framework_modules_relative_dir(platform_group: PlatformGroup) -> Path:
    if is_versioned_macos_framework(platform_group):
        return Path("Versions") / "A" / "Modules"
    return Path("Modules")


def framework_install_name(target_name: str, platform_group: PlatformGroup) -> str:
    return f"@rpath/{target_name}.framework/{framework_binary_relative_path(target_name, platform_group).as_posix()}"


def render_framework_module_map(definition: ArtifactDefinition) -> str:
    header_lines = [
        f'  header "{header_include_path(definition.target_name, relative_path).as_posix()}"'
        for relative_path in definition.public_headers
    ]
    return "\n".join(
        [
            f"framework module {definition.target_name} {{",
            *header_lines,
            "  export *",
            "}",
            "",
        ]
    )


def framework_info_plist_bytes(target_name: str) -> bytes:
    payload = {
        "CFBundleExecutable": framework_binary_name(target_name),
        "CFBundleIdentifier": f"dev.spmforge.libwebp.{target_name}",
        "CFBundleName": target_name,
        "CFBundlePackageType": "FMWK",
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
    }
    return plistlib.dumps(payload, fmt=plistlib.FMT_XML)


def linked_install_name(binary_path: Path, library_name: str) -> str:
    output = command_output(["otool", "-L", str(binary_path)])
    library_stem = library_name.removesuffix(".dylib")
    for raw_line in output.splitlines()[1:]:
        line = raw_line.strip()
        if not line:
            continue
        install_name = line.split(" ", 1)[0]
        if library_stem in install_name:
            return install_name
    raise RuntimeError(f"Unable to locate linked install name for {library_name} in {binary_path}")


def assemble_framework_bundle(
    frameworks_root: Path,
    *,
    definition: ArtifactDefinition,
    built_slice: BuiltSlice,
    headers_root: Path,
) -> Path:
    framework_dir = (
        frameworks_root
        / definition.target_name
        / built_slice.platform_group.identifier
        / f"{definition.target_name}.framework"
    )
    if framework_dir.exists():
        shutil.rmtree(framework_dir)

    headers_dir = framework_dir / framework_headers_relative_dir(built_slice.platform_group)
    modules_dir = framework_dir / framework_modules_relative_dir(built_slice.platform_group)
    resources_dir = framework_dir / framework_resources_relative_dir(built_slice.platform_group)
    headers_dir.mkdir(parents=True, exist_ok=True)
    modules_dir.mkdir(parents=True, exist_ok=True)
    resources_dir.mkdir(parents=True, exist_ok=True)
    shutil.copytree(headers_root, headers_dir, dirs_exist_ok=True)

    binary_path = framework_dir / framework_binary_relative_path(
        definition.target_name,
        built_slice.platform_group,
    )
    binary_path.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(built_slice.binary_path, binary_path)
    run_command(
        [
            "install_name_tool",
            "-id",
            framework_install_name(definition.target_name, built_slice.platform_group),
            str(binary_path),
        ]
    )

    for dependency_name in definition.linked_binary_dependencies:
        dependency = artifact_definition_by_name(dependency_name)
        current_install_name = linked_install_name(binary_path, dependency.library_name)
        run_command(
            [
                "install_name_tool",
                "-change",
                current_install_name,
                framework_install_name(dependency.target_name, built_slice.platform_group),
                str(binary_path),
            ]
        )

    (modules_dir / "module.modulemap").write_text(
        render_framework_module_map(definition),
        encoding="utf-8",
    )
    (resources_dir / "Info.plist").write_bytes(framework_info_plist_bytes(definition.target_name))

    if is_versioned_macos_framework(built_slice.platform_group):
        versions_dir = framework_dir / "Versions"
        current_link = versions_dir / "Current"
        current_link.symlink_to("A")
        for link_name, relative_target in (
            (framework_binary_name(definition.target_name), Path("Versions") / "Current" / framework_binary_name(definition.target_name)),
            ("Headers", Path("Versions") / "Current" / "Headers"),
            ("Modules", Path("Versions") / "Current" / "Modules"),
            ("Resources", Path("Versions") / "Current" / "Resources"),
        ):
            (framework_dir / link_name).symlink_to(relative_target)
    return framework_dir


def create_xcframeworks(
    artifacts_dir: Path,
    build_output: dict[str, list[BuiltSlice]],
    header_paths: dict[str, Path],
) -> dict[str, Path]:
    artifacts_dir.mkdir(parents=True, exist_ok=True)
    created_xcframeworks: dict[str, Path] = {}
    frameworks_root = artifacts_dir / "_frameworks"

    for definition in ARTIFACT_DEFINITIONS:
        xcframework_dir = artifacts_dir / definition.xcframework_name
        arguments = ["xcodebuild", "-create-xcframework"]
        for built_slice in build_output[definition.target_name]:
            framework_dir = assemble_framework_bundle(
                frameworks_root,
                definition=definition,
                built_slice=built_slice,
                headers_root=header_paths[definition.target_name],
            )
            arguments.extend(
                [
                    "-framework",
                    str(framework_dir),
                ]
            )
        arguments.extend(["-output", str(xcframework_dir)])
        run_command(arguments)
        created_xcframeworks[definition.target_name] = xcframework_dir

    return created_xcframeworks


def load_xcframework_info(xcframework_dir: Path) -> dict[str, object]:
    info_path = xcframework_dir / "Info.plist"
    if not info_path.exists():
        raise RuntimeError(f"Missing XCFramework Info.plist: {info_path}")
    return plistlib.loads(info_path.read_bytes())


def matching_library_entry(
    available_libraries: list[dict[str, object]],
    platform_group: PlatformGroup,
) -> dict[str, object]:
    matches = [
        entry
        for entry in available_libraries
        if entry.get("SupportedPlatform") == platform_group.supported_platform
        and entry.get("SupportedPlatformVariant") == platform_group.supported_platform_variant
    ]
    if len(matches) != 1:
        raise RuntimeError(
            f"Expected exactly one XCFramework entry for {platform_group.name}, found {len(matches)}"
        )
    return matches[0]


def validate_binary_platform(binary_path: Path, expected_platform: str) -> None:
    output = command_output(["xcrun", "vtool", "-show-build", str(binary_path)])
    platforms = set(re.findall(r"platform\s+([A-Z0-9_]+)", output))
    if platforms != {expected_platform}:
        raise RuntimeError(
            f"Unexpected build platform metadata for {binary_path}: expected {expected_platform}, got {sorted(platforms)}"
        )


def validate_framework_bundle_layout(framework_dir: Path, *, target_name: str, platform_group: PlatformGroup) -> None:
    if is_versioned_macos_framework(platform_group):
        expected_paths = (
            framework_dir / "Versions" / "Current",
            framework_dir / "Versions" / "A" / framework_binary_name(target_name),
            framework_dir / "Versions" / "A" / "Headers",
            framework_dir / "Versions" / "A" / "Modules" / "module.modulemap",
            framework_dir / "Versions" / "A" / "Resources" / "Info.plist",
            framework_dir / framework_binary_name(target_name),
            framework_dir / "Headers",
            framework_dir / "Modules",
            framework_dir / "Resources",
        )
        missing_paths = [path for path in expected_paths if not path.exists()]
        if missing_paths:
            raise RuntimeError(
                "macOS framework bundle is missing versioned layout paths for "
                + f"{target_name}: {', '.join(str(path) for path in missing_paths)}"
            )
        return

    info_path = framework_dir / "Info.plist"
    if not info_path.exists():
        raise RuntimeError(f"Framework bundle is missing Info.plist: {info_path}")


def validate_xcframeworks(xcframeworks: dict[str, Path]) -> None:
    for definition in ARTIFACT_DEFINITIONS:
        xcframework_dir = xcframeworks[definition.target_name]
        info = load_xcframework_info(xcframework_dir)
        available_libraries = info.get("AvailableLibraries")
        if not isinstance(available_libraries, list):
            raise RuntimeError(
                f"XCFramework metadata for {definition.target_name} is missing AvailableLibraries"
            )
        if len(available_libraries) != len(PLATFORM_GROUPS):
            raise RuntimeError(
                f"XCFramework for {definition.target_name} contains {len(available_libraries)} slices, expected {len(PLATFORM_GROUPS)}"
            )

        for group in PLATFORM_GROUPS:
            entry = matching_library_entry(available_libraries, group)
            if entry.get("MergeableMetadata") is not True:
                raise RuntimeError(
                    f"XCFramework slice for {definition.target_name} on {group.name} is missing MergeableMetadata"
                )
            architectures = entry.get("SupportedArchitectures")
            if sorted(architectures or []) != sorted(group.architectures):
                raise RuntimeError(
                    f"Unexpected architectures for {definition.target_name} on {group.name}: {architectures}"
                )

            library_identifier = entry.get("LibraryIdentifier")
            library_path = entry.get("BinaryPath") or entry.get("LibraryPath")
            if not isinstance(library_identifier, str) or not isinstance(library_path, str):
                raise RuntimeError(
                    f"Incomplete XCFramework metadata for {definition.target_name} on {group.name}"
                )
            binary_path = xcframework_dir / library_identifier / library_path
            if not binary_path.exists():
                raise RuntimeError(f"Missing XCFramework binary slice: {binary_path}")
            validate_framework_bundle_layout(
                xcframework_dir / library_identifier / f"{definition.target_name}.framework",
                target_name=definition.target_name,
                platform_group=group,
            )
            validate_binary_platform(binary_path, group.expected_vtool_platform)


def cmake_quote(value: str) -> str:
    return value.replace("\\", "/").replace('"', '\\"')


def write_cmake_consumer_fixture(consumer_root: Path, xcframeworks: dict[str, Path]) -> tuple[Path, Path]:
    source_dir = consumer_root / "src"
    source_dir.mkdir(parents=True, exist_ok=True)
    cmake_lines = [
        "cmake_minimum_required(VERSION 3.17)",
        "project(spm_libwebp_consumer C)",
        "",
    ]

    for definition in ARTIFACT_DEFINITIONS:
        source_path = source_dir / f"{definition.target_name}.c"
        source_path.write_text(definition.consumer_source, encoding="utf-8")

        library_root = (
            xcframeworks[definition.target_name]
            / "macos-arm64_x86_64"
            / f"{definition.target_name}.framework"
        )
        header_dir = library_root / "Headers"
        framework_search_paths: list[str] = []
        frameworks = []
        for dependency_name in swiftpm_product_targets(definition):
            dependency = artifact_definition_by_name(dependency_name)
            framework_search_path = cmake_quote(
                str(xcframeworks[dependency.target_name] / "macos-arm64_x86_64")
            )
            if framework_search_path not in framework_search_paths:
                framework_search_paths.append(framework_search_path)
            frameworks.append(
                cmake_quote(
                    str(
                        xcframeworks[dependency.target_name]
                        / "macos-arm64_x86_64"
                        / f"{dependency.target_name}.framework"
                        / framework_binary_name(dependency.target_name)
                    )
                )
            )

        target_name = f"Smoke{definition.target_name}"
        cmake_lines.extend(
            [
                f"add_executable({target_name} MACOSX_BUNDLE src/{definition.target_name}.c)",
                f'target_include_directories({target_name} PRIVATE "{cmake_quote(str(header_dir))}")',
                "target_compile_options("
                + target_name
                + " PRIVATE "
                + " ".join(f'"-F{framework_path}"' for framework_path in framework_search_paths)
                + ")",
                "target_link_libraries("
                + target_name
                + " PRIVATE "
                + " ".join(f'"{framework}"' for framework in frameworks)
                + ")",
                "set_target_properties("
                + target_name
                + " PROPERTIES "
                + "XCODE_ATTRIBUTE_CODE_SIGNING_ALLOWED NO "
                + "XCODE_ATTRIBUTE_CODE_SIGNING_REQUIRED NO)",
                "",
            ]
        )

    cmake_path = consumer_root / "CMakeLists.txt"
    cmake_path.write_text("\n".join(cmake_lines), encoding="utf-8")
    build_dir = consumer_root / "build"
    run_command(["cmake", "-S", str(consumer_root), "-B", str(build_dir), "-G", "Xcode"])
    project_paths = sorted(build_dir.glob("*.xcodeproj"))
    if len(project_paths) != 1:
        raise RuntimeError(
            f"Expected exactly one top-level Xcode project in {build_dir}, found {len(project_paths)}"
        )
    project_path = project_paths[0]
    return project_path, build_dir


def verify_cmake_consumer_fixture(xcframeworks: dict[str, Path], work_dir: Path) -> None:
    project_path, build_dir = write_cmake_consumer_fixture(work_dir / "consumer-fixture", xcframeworks)
    macos_group = next(group for group in PLATFORM_GROUPS if group.identifier == "macos")
    macos_deployment_target = deployment_target_version("macos")

    run_command(
        [
            "xcodebuild",
            "-project",
            str(project_path),
            "-scheme",
            "ALL_BUILD",
            "-configuration",
            "Debug",
            "build",
            f"MACOSX_DEPLOYMENT_TARGET={macos_deployment_target}",
            "CODE_SIGNING_ALLOWED=NO",
            "CODE_SIGNING_REQUIRED=NO",
        ],
        capture_output=True,
    )

    release_result = run_command(
        [
            "xcodebuild",
            "-project",
            str(project_path),
            "-scheme",
            "ALL_BUILD",
            "-configuration",
            "Release",
            "build",
            f"MACOSX_DEPLOYMENT_TARGET={macos_deployment_target}",
            "MERGED_BINARY_TYPE=automatic",
            "CODE_SIGNING_ALLOWED=NO",
            "CODE_SIGNING_REQUIRED=NO",
        ],
        capture_output=True,
    )
    release_output = "\n".join(
        fragment for fragment in (release_result.stdout, release_result.stderr) if fragment
    )
    if "MERGED_BINARY_TYPE = automatic" not in release_output:
        raise RuntimeError("Release consumer build did not honor MERGED_BINARY_TYPE=automatic")

    for definition in ARTIFACT_DEFINITIONS:
        target_name = f"Smoke{definition.target_name}"
        debug_binary = build_dir / "Debug" / f"{target_name}.app" / "Contents" / "MacOS" / target_name
        release_binary = build_dir / "Release" / f"{target_name}.app" / "Contents" / "MacOS" / target_name
        if not debug_binary.exists():
            raise RuntimeError(f"Missing Debug consumer binary: {debug_binary}")
        if not release_binary.exists():
            raise RuntimeError(f"Missing Release consumer binary: {release_binary}")

        debug_otool = command_output(["otool", "-L", str(debug_binary)])
        for dependency_name in swiftpm_product_targets(definition):
            expected_install_name = framework_install_name(dependency_name, macos_group)
            if expected_install_name not in debug_otool:
                raise RuntimeError(
                    "Debug consumer binary for "
                    + f"{definition.target_name} is not linked against {expected_install_name}"
                )


def write_spm_binary_package_fixture(binary_package_root: Path, xcframeworks: dict[str, Path]) -> Path:
    binary_package_root.mkdir(parents=True, exist_ok=True)
    artifacts_root = binary_package_root / "Artifacts"
    artifacts_root.mkdir(parents=True, exist_ok=True)
    fixture_paths: dict[str, Path] = {}
    for target_name, xcframework_path in xcframeworks.items():
        link_path = artifacts_root / xcframework_path.name
        if link_path.exists() or link_path.is_symlink():
            if link_path.is_dir() and not link_path.is_symlink():
                shutil.rmtree(link_path)
            else:
                link_path.unlink()
        link_path.symlink_to(xcframework_path.resolve(), target_is_directory=True)
        fixture_paths[target_name] = Path("Artifacts") / xcframework_path.name

    manifest_path = binary_package_root / "Package.swift"
    manifest_path.write_text(
        render_local_binary_package_swift(
            package_name="LocalLibWebPBinary",
            xcframework_paths=fixture_paths,
        ),
        encoding="utf-8",
    )
    return binary_package_root


def write_spm_consumer_fixture(consumer_root: Path, binary_package_root: Path) -> Path:
    sources_dir = consumer_root / "Sources" / "SpmSmokeConsumer"
    sources_dir.mkdir(parents=True, exist_ok=True)
    manifest_path = consumer_root / "Package.swift"
    manifest_path.write_text(
        render_spm_consumer_package_swift(
            binary_package_name="LocalLibWebPBinary",
            binary_package_path=os.path.relpath(binary_package_root, consumer_root),
        ),
        encoding="utf-8",
    )
    for file_name, source in render_spm_consumer_sources().items():
        (sources_dir / file_name).write_text(source, encoding="utf-8")
    return consumer_root


def verify_spm_consumer_fixture(xcframeworks: dict[str, Path], work_dir: Path) -> None:
    binary_package_root = write_spm_binary_package_fixture(
        work_dir / "spm-binary-package",
        xcframeworks,
    )
    consumer_root = write_spm_consumer_fixture(
        work_dir / "spm-consumer-fixture",
        binary_package_root,
    )
    derived_data_path = work_dir / "spm-consumer-derived-data"
    scheme_name = "libwebp-consumer"
    macos_group = next(group for group in PLATFORM_GROUPS if group.identifier == "macos")
    macos_deployment_target = deployment_target_version("macos")

    run_command(["swift", "package", "dump-package"], cwd=binary_package_root, capture_output=True)
    run_command(["swift", "package", "dump-package"], cwd=consumer_root, capture_output=True)

    run_command(
        [
            "xcodebuild",
            "-scheme",
            scheme_name,
            "-configuration",
            "Debug",
            "-derivedDataPath",
            str(derived_data_path),
            "-destination",
            "platform=macOS",
            f"MACOSX_DEPLOYMENT_TARGET={macos_deployment_target}",
            "build",
        ],
        cwd=consumer_root,
        capture_output=True,
    )

    release_result = run_command(
        [
            "xcodebuild",
            "-scheme",
            scheme_name,
            "-configuration",
            "Release",
            "-derivedDataPath",
            str(derived_data_path),
            "-destination",
            "platform=macOS",
            f"MACOSX_DEPLOYMENT_TARGET={macos_deployment_target}",
            "MERGED_BINARY_TYPE=automatic",
            "build",
        ],
        cwd=consumer_root,
        capture_output=True,
    )
    release_output = "\n".join(
        fragment for fragment in (release_result.stdout, release_result.stderr) if fragment
    )
    if "MERGED_BINARY_TYPE = automatic" not in release_output:
        raise RuntimeError("SwiftPM release consumer build did not honor MERGED_BINARY_TYPE=automatic")

    debug_binary = derived_data_path / "Build" / "Products" / "Debug" / "SpmSmokeConsumer"
    release_binary = derived_data_path / "Build" / "Products" / "Release" / "SpmSmokeConsumer"
    if not debug_binary.exists():
        raise RuntimeError(f"Missing SwiftPM Debug consumer binary: {debug_binary}")
    if not release_binary.exists():
        raise RuntimeError(f"Missing SwiftPM Release consumer binary: {release_binary}")

    debug_otool = command_output(["otool", "-L", str(debug_binary)])
    for definition in ARTIFACT_DEFINITIONS:
        expected_install_name = framework_install_name(definition.target_name, macos_group)
        if expected_install_name not in debug_otool:
            raise RuntimeError(
                "SwiftPM Debug consumer binary is not linked against "
                + expected_install_name
            )


def verify_consumer_fixture(xcframeworks: dict[str, Path], work_dir: Path) -> None:
    verify_cmake_consumer_fixture(xcframeworks, work_dir)
    verify_spm_consumer_fixture(xcframeworks, work_dir)


def write_zip_entry(archive: zipfile.ZipFile, source_path: Path, *, archive_root_parent: Path) -> None:
    archive_name = source_path.relative_to(archive_root_parent).as_posix()

    if source_path.is_symlink():
        symlink_entry = zipfile.ZipInfo(archive_name)
        symlink_entry.create_system = 3
        symlink_entry.compress_type = zipfile.ZIP_DEFLATED
        symlink_entry.external_attr = (stat.S_IFLNK | 0o777) << 16
        archive.writestr(symlink_entry, os.readlink(source_path))
        return

    if source_path.is_dir():
        directory_name = archive_name.rstrip("/") + "/"
        directory_entry = zipfile.ZipInfo(directory_name)
        directory_entry.create_system = 3
        directory_entry.compress_type = zipfile.ZIP_DEFLATED
        directory_entry.external_attr = (stat.S_IFDIR | 0o755) << 16 | 0x10
        archive.writestr(directory_entry, b"")
        return

    archive.write(source_path, archive_name)


def write_directory_tree_to_zip(archive: zipfile.ZipFile, root_dir: Path) -> None:
    write_zip_entry(archive, root_dir, archive_root_parent=root_dir.parent)
    for file_path in sorted(root_dir.rglob("*"), key=lambda path: path.as_posix()):
        write_zip_entry(archive, file_path, archive_root_parent=root_dir.parent)


def zip_xcframeworks(tag: str, xcframeworks: dict[str, Path], output_dir: Path) -> list[Path]:
    output_dir.mkdir(parents=True, exist_ok=True)
    artifact_paths: list[Path] = []
    artifacts = {artifact.target_name: artifact for artifact in release_artifacts_for_tag(tag)}

    for target_name, xcframework_dir in xcframeworks.items():
        artifact = artifacts[target_name]
        archive_path = output_dir / artifact.archive_name
        if archive_path.exists():
            archive_path.unlink()
        with zipfile.ZipFile(archive_path, "w", compression=zipfile.ZIP_DEFLATED) as archive:
            write_directory_tree_to_zip(archive, xcframework_dir)
        artifact_paths.append(archive_path)

    return artifact_paths


def retag_release_archives(archives_dir: Path, *, source_tag: str, destination_tag: str) -> list[Path]:
    require_package_distribution_tag(source_tag)
    require_package_distribution_tag(destination_tag)
    archives_dir = archives_dir.resolve()

    source_artifacts = {
        artifact.target_name: artifact for artifact in release_artifacts_for_tag(source_tag)
    }
    destination_artifacts = {
        artifact.target_name: artifact for artifact in release_artifacts_for_tag(destination_tag)
    }
    renamed_paths: list[Path] = []

    for definition in ARTIFACT_DEFINITIONS:
        source_path = archives_dir / source_artifacts[definition.target_name].archive_name
        destination_path = archives_dir / destination_artifacts[definition.target_name].archive_name
        if not source_path.exists():
            raise RuntimeError(f"Missing archive to retag: {source_path}")
        if destination_path.exists() and destination_path != source_path:
            destination_path.unlink()
        if destination_path != source_path:
            source_path.rename(destination_path)
        renamed_paths.append(destination_path)

    return renamed_paths


def build_xcframework_archives(
    *,
    source_dir: Path,
    output_dir: Path,
    tag: str,
    working_dir: Path | None = None,
    keep_xcframeworks: bool = False,
) -> list[Path]:
    require_package_distribution_tag(tag)
    source_dir = source_dir.resolve()
    output_dir = output_dir.resolve()

    if not source_dir.exists():
        raise RuntimeError(f"Source directory does not exist: {source_dir}")

    ensure_build_prerequisites()

    context_manager = (
        tempfile.TemporaryDirectory(prefix="libwebp-build-")
        if working_dir is None
        else None
    )
    root_dir = Path(context_manager.name) if context_manager is not None else working_dir.resolve()
    root_dir.mkdir(parents=True, exist_ok=True)

    try:
        working_source = copy_source_tree(source_dir, root_dir)
        ensure_source_tree_is_buildable(working_source)
        header_paths = prepare_header_directories(working_source, root_dir / "headers")
        build_output = build_archived_libraries(
            source_dir=working_source,
            build_root=root_dir / "cmake-build",
            archives_root=root_dir / "archives",
        )
        xcframework_root = root_dir / "xcframeworks"
        xcframeworks = create_xcframeworks(xcframework_root, build_output, header_paths)
        validate_xcframeworks(xcframeworks)
        verify_consumer_fixture(xcframeworks, root_dir)
        artifact_paths = zip_xcframeworks(tag, xcframeworks, output_dir)

        if keep_xcframeworks:
            kept_dir = output_dir / "xcframeworks"
            if kept_dir.exists():
                shutil.rmtree(kept_dir)
            shutil.copytree(xcframework_root, kept_dir, symlinks=True)

        return artifact_paths
    finally:
        if context_manager is not None:
            context_manager.cleanup()


def compute_checksums_for_archives(archives_dir: Path) -> dict[str, str]:
    archives_dir = archives_dir.resolve()
    checksums: dict[str, str] = {}
    for definition in ARTIFACT_DEFINITIONS:
        matches = sorted(archives_dir.glob(f"{definition.target_name}-v*.xcframework.zip"))
        if len(matches) != 1:
            raise RuntimeError(
                f"Expected exactly one archive for {definition.target_name} in {archives_dir}, found {len(matches)}"
            )
        checksum = command_output(["swift", "package", "compute-checksum", str(matches[0])])
        checksums[definition.target_name] = checksum
    return checksums


def write_json(path: Path, payload: dict[str, object]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def command_output_allowing_not_found(
    args: list[str],
    *,
    cwd: Path | None = None,
    not_found_markers: tuple[str, ...] = GITHUB_NOT_FOUND_MARKERS,
) -> str | None:
    result = subprocess.run(
        args,
        cwd=str(cwd) if cwd is not None else None,
        check=False,
        capture_output=True,
        text=True,
    )
    if result.returncode == 0:
        return result.stdout.strip()

    stdout = result.stdout.strip() if result.stdout else ""
    stderr = result.stderr.strip() if result.stderr else ""
    details = "\n".join(segment for segment in (stdout, stderr) if segment)
    normalized_details = details.lower()
    if any(marker.lower() in normalized_details for marker in not_found_markers):
        return None
    raise RuntimeError(
        f"GitHub CLI command failed with exit code {result.returncode}: {' '.join(args)}"
        + (f"\n{details}" if details else "")
    )


def github_api_json_allowing_not_found(endpoint: str) -> dict[str, object] | None:
    output = command_output_allowing_not_found(["gh", "api", endpoint])
    if output is None:
        return None
    payload = json.loads(output)
    if not isinstance(payload, dict):
        raise RuntimeError(f"Expected a JSON object from gh api {endpoint}, got: {type(payload).__name__}")
    return payload


def inspect_github_release_state(*, repository: str, tag: str) -> GitHubReleaseState:
    release_payload = github_api_json_allowing_not_found(f"repos/{repository}/releases/tags/{tag}")
    if release_payload is None:
        return GitHubReleaseState(
            release_exists=False,
            release_is_prerelease=False,
            release_is_latest=False,
            release_asset_names=(),
            release_id=None,
        )

    release_id = release_payload.get("id")
    if not isinstance(release_id, int):
        raise RuntimeError(f"GitHub release payload for {tag} is missing integer id.")
    release_is_prerelease = release_payload.get("prerelease")
    if not isinstance(release_is_prerelease, bool):
        raise RuntimeError(f"GitHub release payload for {tag} is missing boolean prerelease state.")
    release_assets = release_payload.get("assets")
    if not isinstance(release_assets, list):
        raise RuntimeError(f"GitHub release payload for {tag} is missing an assets list.")

    release_asset_names: list[str] = []
    for asset in release_assets:
        if not isinstance(asset, dict) or not isinstance(asset.get("name"), str):
            raise RuntimeError(f"GitHub release payload for {tag} contains an invalid asset entry.")
        release_asset_names.append(asset["name"])

    latest_payload = github_api_json_allowing_not_found(f"repos/{repository}/releases/latest")
    release_is_latest = False
    if latest_payload is not None:
        latest_tag = latest_payload.get("tag_name")
        if not isinstance(latest_tag, str):
            raise RuntimeError("GitHub latest release payload is missing tag_name.")
        release_is_latest = latest_tag == tag

    return GitHubReleaseState(
        release_exists=True,
        release_is_prerelease=release_is_prerelease,
        release_is_latest=release_is_latest,
        release_asset_names=tuple(release_asset_names),
        release_id=release_id,
    )


def read_optional_git_file(ref: str, relative_path: str) -> str | None:
    result = subprocess.run(
        ["git", "show", f"{ref}:{relative_path}"],
        check=False,
        capture_output=True,
        text=True,
    )
    if result.returncode == 0:
        return result.stdout
    return None


def render_and_validate_package_manifest(
    *,
    owner: str,
    repository: str,
    tag: str,
    checksums_json_path: Path,
    metadata_dir: Path,
    validation_dir: Path,
) -> str:
    checksums = validate_checksums_payload(json.loads(checksums_json_path.read_text(encoding="utf-8")))
    package_swift = render_package_swift(
        owner=owner,
        repository=repository,
        tag=tag,
        checksums=checksums,
    )
    package_swift_path = metadata_dir / "Package.swift"
    package_swift_path.parent.mkdir(parents=True, exist_ok=True)
    package_swift_path.write_text(package_swift, encoding="utf-8")

    validation_dir.mkdir(parents=True, exist_ok=True)
    (validation_dir / "Package.swift").write_text(package_swift, encoding="utf-8")
    run_command(["swift", "package", "dump-package", "--package-path", str(validation_dir)])
    return package_swift


def write_release_notes(
    metadata_dir: Path,
    *,
    selection_mode: str,
    release_channel: str,
    final_package_tag: str,
    upstream_tag: str,
    upstream_commit: str,
) -> Path:
    if selection_mode == "latest":
        summary_line = (
            f"Automated {release_channel} mergeable binary release {final_package_tag} "
            f"for upstream libwebp {upstream_tag}."
        )
    else:
        summary_line = (
            f"Manual {release_channel} mergeable binary release {final_package_tag} "
            f"for upstream libwebp {upstream_tag}."
        )

    release_notes_path = metadata_dir / "release-notes.md"
    release_notes_path.write_text(
        "\n".join(
            [
                summary_line,
                "",
                f"Upstream source commit: {upstream_commit}",
                "",
                "Published artifacts:",
                "- Mergeable WebP.xcframework.zip",
                "- Mergeable WebPDecoder.xcframework.zip",
                "- Mergeable WebPDemux.xcframework.zip",
                "- Mergeable WebPMux.xcframework.zip",
                "- Mergeable SharpYuv.xcframework.zip",
                "- checksums.json",
                "",
            ]
        ),
        encoding="utf-8",
    )
    return release_notes_path


def prepare_release_publication(
    *,
    selection_mode: str,
    release_channel: str,
    upstream_tag: str,
    upstream_commit: str,
    build_tag: str,
    latest_package_tag: str | None,
    next_package_tag: str | None,
    remote_tag_exists: bool,
    remote_tag_commit: str | None,
    artifacts_dir: Path,
    metadata_dir: Path,
    validation_dir: Path,
    package_owner: str,
    package_repository: str,
    github_repository: str,
) -> PreparedReleasePublication:
    if selection_mode not in {"latest", "requested"}:
        raise ValueError(f"Unsupported selection_mode: {selection_mode}")
    if release_channel not in {"alpha", "stable"}:
        raise ValueError(f"Unsupported release_channel: {release_channel}")
    if remote_tag_exists and not remote_tag_commit:
        raise ValueError("remote_tag_commit is required when remote_tag_exists is true.")

    checksums_json_path = metadata_dir / "checksums.json"
    if not checksums_json_path.exists():
        raise RuntimeError(f"Missing checksums payload: {checksums_json_path}")

    final_package_tag = build_tag
    final_remote_tag_exists = remote_tag_exists
    final_remote_tag_commit = remote_tag_commit
    rendered_package_swift = render_and_validate_package_manifest(
        owner=package_owner,
        repository=package_repository,
        tag=build_tag,
        checksums_json_path=checksums_json_path,
        metadata_dir=metadata_dir,
        validation_dir=validation_dir,
    )
    candidate_package_swift: str | None = None

    if release_channel == "stable":
        if final_remote_tag_exists:
            candidate_package_swift = read_optional_git_file(f"refs/tags/{final_package_tag}", "Package.swift")
            if candidate_package_swift is None:
                raise RuntimeError(
                    f"Stable package tag {final_package_tag} already exists without Package.swift; "
                    "refusing to overwrite it."
                )
    else:
        if latest_package_tag:
            latest_package_swift = read_optional_git_file(f"refs/tags/{latest_package_tag}", "Package.swift")
            if latest_package_swift is not None and latest_package_swift == rendered_package_swift:
                if not final_remote_tag_exists or not final_remote_tag_commit:
                    raise ValueError(
                        "latest_package_tag matched the rendered package, but the remote tag state is incomplete."
                    )
                final_package_tag = latest_package_tag
                candidate_package_swift = latest_package_swift
            else:
                if not next_package_tag:
                    raise ValueError(
                        "next_package_tag is required when the latest alpha tag does not match the rendered package."
                    )
                final_package_tag = next_package_tag
                final_remote_tag_exists = False
                final_remote_tag_commit = None

        if final_package_tag != build_tag:
            retag_release_archives(
                artifacts_dir,
                source_tag=build_tag,
                destination_tag=final_package_tag,
            )
            rendered_package_swift = render_and_validate_package_manifest(
                owner=package_owner,
                repository=package_repository,
                tag=final_package_tag,
                checksums_json_path=checksums_json_path,
                metadata_dir=metadata_dir,
                validation_dir=validation_dir,
            )

    if final_remote_tag_exists and not final_remote_tag_commit:
        raise ValueError("remote_tag_commit is required for an existing final package tag.")

    release_state = GitHubReleaseState(
        release_exists=False,
        release_is_prerelease=False,
        release_is_latest=False,
        release_asset_names=(),
        release_id=None,
    )
    if final_remote_tag_exists:
        release_state = inspect_github_release_state(
            repository=github_repository,
            tag=final_package_tag,
        )

    resolution = resolve_release_publication(
        release_channel=release_channel,
        build_tag=final_package_tag,
        latest_package_tag=None,
        rendered_package_swift=rendered_package_swift,
        candidate_package_swift=candidate_package_swift,
        release_asset_names=release_state.release_asset_names,
        release_exists=release_state.release_exists,
        release_is_prerelease=release_state.release_is_prerelease,
        release_is_latest=release_state.release_is_latest,
        remote_tag_exists=final_remote_tag_exists,
        remote_tag_commit=final_remote_tag_commit,
    )

    write_release_notes(
        metadata_dir,
        selection_mode=selection_mode,
        release_channel=release_channel,
        final_package_tag=resolution.final_package_tag,
        upstream_tag=upstream_tag,
        upstream_commit=upstream_commit,
    )

    return PreparedReleasePublication(
        final_package_tag=resolution.final_package_tag,
        mode=resolution.mode,
        required_assets=resolution.required_assets,
        missing_assets=resolution.missing_assets,
        metadata_needs_repair=resolution.metadata_needs_repair,
        release_exists=resolution.release_exists,
        remote_tag_exists=resolution.remote_tag_exists,
        remote_tag_commit=resolution.remote_tag_commit,
        release_id=release_state.release_id,
        release_is_prerelease=release_state.release_is_prerelease,
        release_is_latest=release_state.release_is_latest,
    )


def write_github_outputs(path: Path, outputs: dict[str, str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as handle:
        for key, value in outputs.items():
            handle.write(f"{key}={value}\n")


def command_latest_stable_tag(args: argparse.Namespace) -> int:
    print(select_latest_stable_tag(read_tags_from_cli_or_stdin(args.tags)))
    return 0


def command_assert_stable_tag(args: argparse.Namespace) -> int:
    require_stable_tag(args.tag)
    print(args.tag)
    return 0


def command_fetch_upstream_tags(args: argparse.Namespace) -> int:
    fetch_upstream_tags(args.remote)
    return 0


def command_latest_fetched_upstream_stable_tag(_: argparse.Namespace) -> int:
    print(latest_fetched_upstream_stable_tag())
    return 0


def command_export_upstream_source(args: argparse.Namespace) -> int:
    export_upstream_source_tree(args.tag, Path(args.output_dir))
    return 0


def command_package_release_tag(args: argparse.Namespace) -> int:
    print(
        package_release_tag_for_upstream_tag(
            args.upstream_tag,
            channel=args.channel,
            sequence=args.sequence,
        )
    )
    return 0


def command_latest_package_release_tag(args: argparse.Namespace) -> int:
    latest_tag = latest_package_release_tag_for_upstream_tag(
        args.upstream_tag,
        read_tags_from_cli_or_stdin(args.tags),
    )
    if latest_tag is None:
        return 1
    print(latest_tag)
    return 0


def command_next_package_release_tag(args: argparse.Namespace) -> int:
    print(
        next_package_release_tag_for_upstream_tag(
            args.upstream_tag,
            read_tags_from_cli_or_stdin(args.tags),
        )
    )
    return 0


def command_release_artifacts(args: argparse.Namespace) -> int:
    artifacts = [dataclasses.asdict(artifact) for artifact in release_artifacts_for_tag(args.tag)]
    print(json.dumps({"artifacts": artifacts}, indent=2))
    return 0


def command_release_publish_plan(args: argparse.Namespace) -> int:
    plan = plan_release_publication(
        tag=args.tag,
        remote_tag_exists=args.tag_exists,
        release_asset_names=args.assets,
    )
    print(json.dumps(dataclasses.asdict(plan), indent=2))
    return 0


def _read_optional_text(path_value: str | None) -> str | None:
    if not path_value:
        return None
    return Path(path_value).read_text(encoding="utf-8")


def _read_release_asset_names(path_value: str) -> tuple[str, ...]:
    release_assets_path = Path(path_value)
    if not release_assets_path.exists():
        return ()
    asset_names = [line.strip() for line in release_assets_path.read_text(encoding="utf-8").splitlines()]
    return tuple(asset_name for asset_name in asset_names if asset_name)


def command_resolve_release_publication(args: argparse.Namespace) -> int:
    resolution = resolve_release_publication(
        release_channel=args.release_channel,
        build_tag=args.build_tag,
        latest_package_tag=args.latest_package_tag or None,
        rendered_package_swift=Path(args.rendered_package_swift).read_text(encoding="utf-8"),
        candidate_package_swift=_read_optional_text(args.candidate_package_swift or None),
        release_asset_names=_read_release_asset_names(args.release_assets_file),
        release_exists=args.release_exists,
        release_is_prerelease=args.release_is_prerelease,
        release_is_latest=args.release_is_latest,
        remote_tag_exists=args.remote_tag_exists,
        remote_tag_commit=args.remote_tag_commit or None,
    )
    print(json.dumps(dataclasses.asdict(resolution), indent=2))
    return 0


def command_prepare_release_publication(args: argparse.Namespace) -> int:
    resolution = prepare_release_publication(
        selection_mode=args.selection_mode,
        release_channel=args.release_channel,
        upstream_tag=args.upstream_tag,
        upstream_commit=args.upstream_commit,
        build_tag=args.build_tag,
        latest_package_tag=args.latest_package_tag or None,
        next_package_tag=args.next_package_tag or None,
        remote_tag_exists=args.remote_tag_exists,
        remote_tag_commit=args.remote_tag_commit or None,
        artifacts_dir=Path(args.artifacts_dir),
        metadata_dir=Path(args.metadata_dir),
        validation_dir=Path(args.validation_dir),
        package_owner=args.package_owner,
        package_repository=args.package_repository,
        github_repository=args.github_repository,
    )
    if args.github_output:
        write_github_outputs(
            Path(args.github_output),
            {
                "package_tag": resolution.final_package_tag,
                "mode": resolution.mode,
                "release_exists": str(resolution.release_exists).lower(),
                "remote_tag_exists": str(resolution.remote_tag_exists).lower(),
                "remote_tag_commit": resolution.remote_tag_commit or "",
                "missing_assets": ",".join(resolution.missing_assets),
                "metadata_needs_repair": str(resolution.metadata_needs_repair).lower(),
            },
        )
    print(json.dumps(dataclasses.asdict(resolution), indent=2))
    return 0


def command_print_build_plan(_: argparse.Namespace) -> int:
    print(json.dumps(build_plan_payload(), indent=2))
    return 0


def command_render_package_swift(args: argparse.Namespace) -> int:
    checksums = validate_checksums_payload(
        json.loads(Path(args.checksums_json).read_text(encoding="utf-8"))
    )
    package_swift = render_package_swift(
        owner=args.owner,
        repository=args.repository,
        tag=args.tag,
        checksums=checksums,
    )
    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(package_swift, encoding="utf-8")
    return 0


def command_compute_checksums(args: argparse.Namespace) -> int:
    write_json(Path(args.output), compute_checksums_for_archives(Path(args.archives_dir)))
    return 0


def command_build_xcframeworks(args: argparse.Namespace) -> int:
    artifact_paths = build_xcframework_archives(
        source_dir=Path(args.source_dir),
        output_dir=Path(args.output_dir),
        tag=args.tag,
        working_dir=Path(args.working_dir) if args.working_dir else None,
        keep_xcframeworks=args.keep_xcframeworks,
    )
    print(json.dumps({"archives": [str(path) for path in artifact_paths]}, indent=2))
    return 0


def command_retag_archives(args: argparse.Namespace) -> int:
    retagged_paths = retag_release_archives(
        Path(args.archives_dir),
        source_tag=args.source_tag,
        destination_tag=args.destination_tag,
    )
    print(json.dumps({"archives": [str(path) for path in retagged_paths]}, indent=2))
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="SwiftPM release helpers for libwebp.")
    subparsers = parser.add_subparsers(dest="command", required=True)

    latest_parser = subparsers.add_parser(
        "latest-stable-tag",
        help="Select the newest stable upstream tag from CLI args or stdin.",
    )
    latest_parser.add_argument("tags", nargs="*")
    latest_parser.set_defaults(func=command_latest_stable_tag)

    assert_parser = subparsers.add_parser(
        "assert-stable-tag",
        help="Validate a tag string matches the stable libwebp release format.",
    )
    assert_parser.add_argument("--tag", required=True)
    assert_parser.set_defaults(func=command_assert_stable_tag)

    fetch_upstream_tags_parser = subparsers.add_parser(
        "fetch-upstream-tags",
        help="Fetch upstream tags into the configured dedicated namespace.",
    )
    fetch_upstream_tags_parser.add_argument("--remote", default="upstream")
    fetch_upstream_tags_parser.set_defaults(func=command_fetch_upstream_tags)

    latest_fetched_upstream_stable_tag_parser = subparsers.add_parser(
        "latest-fetched-upstream-stable-tag",
        help="Select the newest stable upstream tag from the configured fetched namespace.",
    )
    latest_fetched_upstream_stable_tag_parser.set_defaults(
        func=command_latest_fetched_upstream_stable_tag
    )

    export_upstream_source_parser = subparsers.add_parser(
        "export-upstream-source",
        help="Export a fetched upstream stable tag into a local source snapshot directory.",
    )
    export_upstream_source_parser.add_argument("--tag", required=True)
    export_upstream_source_parser.add_argument("--output-dir", required=True)
    export_upstream_source_parser.set_defaults(func=command_export_upstream_source)

    package_release_tag_parser = subparsers.add_parser(
        "package-release-tag",
        help="Derive a package tag for a stable upstream libwebp tag.",
    )
    package_release_tag_parser.add_argument("--upstream-tag", required=True)
    package_release_tag_parser.add_argument(
        "--channel",
        choices=("alpha", "stable"),
        default="alpha",
    )
    package_release_tag_parser.add_argument("--sequence", type=int)
    package_release_tag_parser.set_defaults(func=command_package_release_tag)

    latest_package_release_tag_parser = subparsers.add_parser(
        "latest-package-release-tag",
        help="Select the newest package prerelease tag for an upstream stable tag from CLI args or stdin.",
    )
    latest_package_release_tag_parser.add_argument("--upstream-tag", required=True)
    latest_package_release_tag_parser.add_argument("tags", nargs="*")
    latest_package_release_tag_parser.set_defaults(func=command_latest_package_release_tag)

    next_package_release_tag_parser = subparsers.add_parser(
        "next-package-release-tag",
        help="Compute the next package prerelease tag for an upstream stable tag from CLI args or stdin.",
    )
    next_package_release_tag_parser.add_argument("--upstream-tag", required=True)
    next_package_release_tag_parser.add_argument("tags", nargs="*")
    next_package_release_tag_parser.set_defaults(func=command_next_package_release_tag)

    release_artifacts_parser = subparsers.add_parser(
        "release-artifacts",
        help="Print JSON describing the release assets for a package release tag.",
    )
    release_artifacts_parser.add_argument("--tag", required=True)
    release_artifacts_parser.set_defaults(func=command_release_artifacts)

    release_publish_plan_parser = subparsers.add_parser(
        "release-publish-plan",
        help="Plan whether a tag should publish fresh assets, repair an incomplete release, or skip.",
    )
    release_publish_plan_parser.add_argument("--tag", required=True)
    release_publish_plan_parser.add_argument("--tag-exists", action="store_true")
    release_publish_plan_parser.add_argument("--asset", dest="assets", action="append", default=[])
    release_publish_plan_parser.set_defaults(func=command_release_publish_plan)

    resolve_release_publication_parser = subparsers.add_parser(
        "resolve-release-publication",
        help="Resolve the final publication tag and release mode from rendered package state.",
    )
    resolve_release_publication_parser.add_argument(
        "--release-channel",
        choices=("alpha", "stable"),
        required=True,
    )
    resolve_release_publication_parser.add_argument("--build-tag", required=True)
    resolve_release_publication_parser.add_argument("--latest-package-tag", default="")
    resolve_release_publication_parser.add_argument("--rendered-package-swift", required=True)
    resolve_release_publication_parser.add_argument("--candidate-package-swift", default="")
    resolve_release_publication_parser.add_argument("--release-assets-file", required=True)
    resolve_release_publication_parser.add_argument("--remote-tag-commit", default="")
    resolve_release_publication_parser.add_argument("--release-exists", action="store_true")
    resolve_release_publication_parser.add_argument("--release-is-prerelease", action="store_true")
    resolve_release_publication_parser.add_argument("--release-is-latest", action="store_true")
    resolve_release_publication_parser.add_argument("--remote-tag-exists", action="store_true")
    resolve_release_publication_parser.set_defaults(func=command_resolve_release_publication)

    prepare_release_publication_parser = subparsers.add_parser(
        "prepare-release-publication",
        help="Render the final Package.swift, inspect GitHub release state, and emit publication outputs.",
    )
    prepare_release_publication_parser.add_argument(
        "--selection-mode",
        choices=("latest", "requested"),
        required=True,
    )
    prepare_release_publication_parser.add_argument(
        "--release-channel",
        choices=("alpha", "stable"),
        required=True,
    )
    prepare_release_publication_parser.add_argument("--upstream-tag", required=True)
    prepare_release_publication_parser.add_argument("--upstream-commit", required=True)
    prepare_release_publication_parser.add_argument("--build-tag", required=True)
    prepare_release_publication_parser.add_argument("--latest-package-tag", default="")
    prepare_release_publication_parser.add_argument("--next-package-tag", default="")
    prepare_release_publication_parser.add_argument("--remote-tag-commit", default="")
    prepare_release_publication_parser.add_argument("--artifacts-dir", required=True)
    prepare_release_publication_parser.add_argument("--metadata-dir", required=True)
    prepare_release_publication_parser.add_argument("--validation-dir", required=True)
    prepare_release_publication_parser.add_argument("--package-owner", required=True)
    prepare_release_publication_parser.add_argument("--package-repository", required=True)
    prepare_release_publication_parser.add_argument("--github-repository", required=True)
    prepare_release_publication_parser.add_argument("--github-output", default="")
    prepare_release_publication_parser.add_argument("--remote-tag-exists", action="store_true")
    prepare_release_publication_parser.set_defaults(func=command_prepare_release_publication)

    build_plan_parser = subparsers.add_parser(
        "print-build-plan",
        help="Print the supported Apple platform matrix as JSON.",
    )
    build_plan_parser.set_defaults(func=command_print_build_plan)

    render_package_parser = subparsers.add_parser(
        "render-package-swift",
        help="Render a Package.swift that references package prerelease assets.",
    )
    render_package_parser.add_argument("--owner", required=True)
    render_package_parser.add_argument("--repository", required=True)
    render_package_parser.add_argument("--tag", required=True)
    render_package_parser.add_argument("--checksums-json", required=True)
    render_package_parser.add_argument("--output", required=True)
    render_package_parser.set_defaults(func=command_render_package_swift)

    checksum_parser = subparsers.add_parser(
        "compute-checksums",
        help="Compute SwiftPM SHA-256 checksums for the versioned XCFramework archives.",
    )
    checksum_parser.add_argument("--archives-dir", required=True)
    checksum_parser.add_argument("--output", required=True)
    checksum_parser.set_defaults(func=command_compute_checksums)

    build_xcframeworks_parser = subparsers.add_parser(
        "build-xcframeworks",
        help="Build and archive all release XCFrameworks for a package release tag.",
    )
    build_xcframeworks_parser.add_argument("--source-dir", required=True)
    build_xcframeworks_parser.add_argument("--output-dir", required=True)
    build_xcframeworks_parser.add_argument("--tag", required=True)
    build_xcframeworks_parser.add_argument("--working-dir")
    build_xcframeworks_parser.add_argument("--keep-xcframeworks", action="store_true")
    build_xcframeworks_parser.set_defaults(func=command_build_xcframeworks)

    retag_archives_parser = subparsers.add_parser(
        "retag-archives",
        help="Rename packaged XCFramework archives from one package release tag to another.",
    )
    retag_archives_parser.add_argument("--archives-dir", required=True)
    retag_archives_parser.add_argument("--source-tag", required=True)
    retag_archives_parser.add_argument("--destination-tag", required=True)
    retag_archives_parser.set_defaults(func=command_retag_archives)

    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())

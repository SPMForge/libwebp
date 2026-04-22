import importlib.util
import json
import shutil
import stat
import subprocess
import sys
import tempfile
import unittest
import zipfile
from unittest import mock
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
MODULE_PATH = REPO_ROOT / "scripts" / "spm_release.py"
BUILD_SCRIPT_PATH = REPO_ROOT / "scripts" / "build_apple_xcframeworks.sh"
SOURCE_ACQUISITION_CONFIG_PATH = REPO_ROOT / "config" / "source-acquisition.json"
PUBLISH_LATEST_WORKFLOW_PATH = (
    REPO_ROOT / ".github" / "workflows" / "publish-latest-upstream-alpha.yml"
)
PUBLISH_MANUAL_WORKFLOW_PATH = (
    REPO_ROOT / ".github" / "workflows" / "publish-upstream-release-manually.yml"
)
PUBLISH_CORE_WORKFLOW_PATH = (
    REPO_ROOT / ".github" / "workflows" / "publish-package-release-core.yml"
)
VALIDATE_WORKFLOW_PATH = (
    REPO_ROOT / ".github" / "workflows" / "validate-apple-release-pipeline.yml"
)
UPSTREAM_TAG = "v1.6.0"
PACKAGE_TAG = "v1.6.0-alpha.1"


def load_spm_release_module():
    if not MODULE_PATH.exists():
        raise AssertionError(f"missing module: {MODULE_PATH}")
    spec = importlib.util.spec_from_file_location("spm_release", MODULE_PATH)
    if spec is None or spec.loader is None:
        raise AssertionError(f"unable to load module spec: {MODULE_PATH}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


class StableTagSelectionTests(unittest.TestCase):
    def test_select_latest_stable_tag_ignores_prereleases_and_nonrelease_tags(self):
        module = load_spm_release_module()

        latest = module.select_latest_stable_tag(
            [
                "webp-rfc9649",
                "v1.5.0-rc1",
                "v1.5.0",
                "v1.6.0-rc1",
                "v1.6.0",
                "v1.4.9",
            ]
        )

        self.assertEqual(latest, "v1.6.0")

    def test_select_latest_stable_tag_rejects_when_no_stable_release_exists(self):
        module = load_spm_release_module()

        with self.assertRaisesRegex(ValueError, "stable release tag"):
            module.select_latest_stable_tag(["webp-rfc9649", "v1.6.0-rc1"])


class PackageReleaseTagTests(unittest.TestCase):
    def test_package_release_tag_for_upstream_tag_appends_alpha_suffix(self):
        module = load_spm_release_module()

        self.assertEqual(module.package_release_tag_for_upstream_tag(UPSTREAM_TAG), PACKAGE_TAG)

    def test_package_release_tag_for_upstream_tag_can_return_stable_tag(self):
        module = load_spm_release_module()

        self.assertEqual(
            module.package_release_tag_for_upstream_tag(UPSTREAM_TAG, channel="stable"),
            UPSTREAM_TAG,
        )

    def test_package_release_tag_for_upstream_tag_accepts_explicit_sequence(self):
        module = load_spm_release_module()

        self.assertEqual(
            module.package_release_tag_for_upstream_tag(UPSTREAM_TAG, sequence=3),
            "v1.6.0-alpha.3",
        )

    def test_latest_package_release_tag_for_upstream_tag_ignores_other_channels(self):
        module = load_spm_release_module()

        latest = module.latest_package_release_tag_for_upstream_tag(
            UPSTREAM_TAG,
            [
                "v1.6.0-alpha.1",
                "v1.6.0-alpha.3",
                "v1.6.0-rc1",
                "v1.6.0",
                "v1.5.9-alpha.9",
                "v1.6.0-alpha.2",
            ],
        )

        self.assertEqual(latest, "v1.6.0-alpha.3")

    def test_next_package_release_tag_for_upstream_tag_increments_existing_sequence(self):
        module = load_spm_release_module()

        next_tag = module.next_package_release_tag_for_upstream_tag(
            UPSTREAM_TAG,
            ["v1.6.0-alpha.2", "v1.6.0-alpha.7"],
        )

        self.assertEqual(next_tag, "v1.6.0-alpha.8")

    def test_require_package_release_tag_rejects_upstream_stable_tag(self):
        module = load_spm_release_module()

        with self.assertRaisesRegex(ValueError, "package release tag"):
            module.require_package_release_tag(UPSTREAM_TAG)

    def test_require_package_distribution_tag_accepts_stable_tag(self):
        module = load_spm_release_module()

        self.assertEqual(module.require_package_distribution_tag(UPSTREAM_TAG), UPSTREAM_TAG)


class ReleaseArtifactTests(unittest.TestCase):
    def test_release_artifacts_are_versioned_xcframework_archives(self):
        module = load_spm_release_module()

        artifacts = module.release_artifacts_for_tag(PACKAGE_TAG)
        artifact_names = [artifact.archive_name for artifact in artifacts]

        self.assertEqual(
            artifact_names,
            [
                "WebP-v1.6.0-alpha.1.xcframework.zip",
                "WebPDecoder-v1.6.0-alpha.1.xcframework.zip",
                "WebPDemux-v1.6.0-alpha.1.xcframework.zip",
                "WebPMux-v1.6.0-alpha.1.xcframework.zip",
                "SharpYuv-v1.6.0-alpha.1.xcframework.zip",
            ],
        )

    def test_release_artifacts_support_stable_package_tags(self):
        module = load_spm_release_module()

        artifacts = module.release_artifacts_for_tag(UPSTREAM_TAG)
        artifact_names = [artifact.archive_name for artifact in artifacts]

        self.assertEqual(
            artifact_names,
            [
                "WebP-v1.6.0.xcframework.zip",
                "WebPDecoder-v1.6.0.xcframework.zip",
                "WebPDemux-v1.6.0.xcframework.zip",
                "WebPMux-v1.6.0.xcframework.zip",
                "SharpYuv-v1.6.0.xcframework.zip",
            ],
        )

    def test_release_artifacts_use_mergeable_dylib_payloads(self):
        module = load_spm_release_module()

        artifacts = module.release_artifacts_for_tag(PACKAGE_TAG)
        library_names = [artifact.library_name for artifact in artifacts]

        self.assertEqual(
            library_names,
            [
                "libwebp.dylib",
                "libwebpdecoder.dylib",
                "libwebpdemux.dylib",
                "libwebpmux.dylib",
                "libsharpyuv.dylib",
            ],
        )

    def test_retag_release_archives_renames_all_archives_for_new_alpha_sequence(self):
        module = load_spm_release_module()

        with tempfile.TemporaryDirectory() as temp_dir:
            archives_dir = Path(temp_dir)
            for artifact in module.release_artifacts_for_tag(PACKAGE_TAG):
                (archives_dir / artifact.archive_name).write_text("fixture\n", encoding="utf-8")

            retagged_paths = module.retag_release_archives(
                archives_dir,
                source_tag=PACKAGE_TAG,
                destination_tag="v1.6.0-alpha.2",
            )

            self.assertEqual(len(retagged_paths), len(module.ARTIFACT_DEFINITIONS))
            self.assertFalse((archives_dir / "WebP-v1.6.0-alpha.1.xcframework.zip").exists())
            self.assertTrue((archives_dir / "WebP-v1.6.0-alpha.2.xcframework.zip").exists())

    def test_artifact_definitions_capture_direct_linked_binary_dependencies(self):
        module = load_spm_release_module()

        self.assertEqual(
            module.artifact_definition_by_name("WebP").linked_binary_dependencies,
            ("SharpYuv",),
        )
        self.assertEqual(
            module.artifact_definition_by_name("WebPDecoder").linked_binary_dependencies,
            (),
        )
        self.assertEqual(
            module.artifact_definition_by_name("WebPDemux").linked_binary_dependencies,
            ("WebP", "SharpYuv"),
        )
        self.assertEqual(
            module.artifact_definition_by_name("WebPMux").linked_binary_dependencies,
            ("WebP", "SharpYuv"),
        )
        self.assertEqual(
            module.artifact_definition_by_name("SharpYuv").linked_binary_dependencies,
            (),
        )

    def test_zip_xcframeworks_preserves_macos_framework_symlinks(self):
        module = load_spm_release_module()

        with tempfile.TemporaryDirectory() as temp_dir:
            temp_path = Path(temp_dir)
            xcframework_dir = temp_path / "WebP.xcframework"
            framework_dir = xcframework_dir / "macos-arm64_x86_64" / "WebP.framework"
            resources_dir = framework_dir / "Versions" / "A" / "Resources"
            resources_dir.mkdir(parents=True)
            (resources_dir / "Info.plist").write_text("plist\n", encoding="utf-8")
            (framework_dir / "Versions" / "Current").symlink_to("A")
            (framework_dir / "Resources").symlink_to(Path("Versions") / "Current" / "Resources")

            output_dir = temp_path / "artifacts"
            [archive_path] = module.zip_xcframeworks(
                PACKAGE_TAG,
                {"WebP": xcframework_dir},
                output_dir,
            )

            with zipfile.ZipFile(archive_path) as archive:
                entries = {info.filename: info for info in archive.infolist()}

            current_info = entries[
                "WebP.xcframework/macos-arm64_x86_64/WebP.framework/Versions/Current"
            ]
            resources_info = entries[
                "WebP.xcframework/macos-arm64_x86_64/WebP.framework/Resources"
            ]
            self.assertTrue(stat.S_ISLNK(current_info.external_attr >> 16))
            self.assertTrue(stat.S_ISLNK(resources_info.external_attr >> 16))

            if shutil.which("ditto") is not None:
                extracted_root = temp_path / "extracted"
                extracted_root.mkdir()
                subprocess.run(
                    ["ditto", "-x", "-k", str(archive_path), str(extracted_root)],
                    check=True,
                )
                current_link = (
                    extracted_root
                    / "WebP.xcframework"
                    / "macos-arm64_x86_64"
                    / "WebP.framework"
                    / "Versions"
                    / "Current"
                )
                resources_link = (
                    extracted_root
                    / "WebP.xcframework"
                    / "macos-arm64_x86_64"
                    / "WebP.framework"
                    / "Resources"
                )
                self.assertTrue(current_link.is_symlink())
                self.assertEqual(current_link.readlink(), Path("A"))
                self.assertTrue(resources_link.is_symlink())
                self.assertEqual(
                    resources_link.readlink(),
                    Path("Versions") / "Current" / "Resources",
                )

    def test_render_package_swift_uses_release_asset_download_urls(self):
        module = load_spm_release_module()

        package_swift = module.render_package_swift(
            owner="RbBtSn0w",
            repository="spm-libwebp",
            tag=PACKAGE_TAG,
            checksums={
                "WebP": "1" * 64,
                "WebPDecoder": "2" * 64,
                "WebPDemux": "3" * 64,
                "WebPMux": "4" * 64,
                "SharpYuv": "5" * 64,
            },
        )

        self.assertIn('.library(name: "WebP", targets: ["WebP", "SharpYuv"])', package_swift)
        self.assertIn(
            '.library(name: "WebPDemux", targets: ["WebPDemux", "WebP", "SharpYuv"])',
            package_swift,
        )
        self.assertIn(
            '.library(name: "WebPMux", targets: ["WebPMux", "WebP", "SharpYuv"])',
            package_swift,
        )
        self.assertIn('name: "libwebp"', package_swift)
        self.assertIn(
            'url: "https://github.com/RbBtSn0w/spm-libwebp/releases/download/v1.6.0-alpha.1/WebP-v1.6.0-alpha.1.xcframework.zip"',
            package_swift,
        )
        self.assertIn('checksum: "' + ("1" * 64) + '"', package_swift)

    def test_render_package_swift_fails_fast_on_missing_checksum(self):
        module = load_spm_release_module()

        with self.assertRaisesRegex(ValueError, "Missing checksum"):
            module.render_package_swift(
                owner="RbBtSn0w",
                repository="spm-libwebp",
                tag=PACKAGE_TAG,
                checksums={
                    "WebP": "1" * 64,
                    "WebPDecoder": "2" * 64,
                    "WebPDemux": "3" * 64,
                    "WebPMux": "4" * 64,
                },
            )


class ReleasePublicationPlanTests(unittest.TestCase):
    def test_required_release_asset_names_include_archives_and_checksums(self):
        module = load_spm_release_module()

        self.assertEqual(
            module.required_release_asset_names(PACKAGE_TAG),
            (
                "WebP-v1.6.0-alpha.1.xcframework.zip",
                "WebPDecoder-v1.6.0-alpha.1.xcframework.zip",
                "WebPDemux-v1.6.0-alpha.1.xcframework.zip",
                "WebPMux-v1.6.0-alpha.1.xcframework.zip",
                "SharpYuv-v1.6.0-alpha.1.xcframework.zip",
                "checksums.json",
            ),
        )

    def test_plan_release_publication_uses_fresh_mode_for_new_tags(self):
        module = load_spm_release_module()

        plan = module.plan_release_publication(
            tag=PACKAGE_TAG,
            remote_tag_exists=False,
            release_asset_names=(),
        )

        self.assertEqual(plan.mode, "fresh")
        self.assertEqual(plan.missing_assets, module.required_release_asset_names(PACKAGE_TAG))

    def test_plan_release_publication_uses_repair_mode_when_assets_are_missing(self):
        module = load_spm_release_module()

        plan = module.plan_release_publication(
            tag=PACKAGE_TAG,
            remote_tag_exists=True,
            release_asset_names=("WebP-v1.6.0-alpha.1.xcframework.zip",),
        )

        self.assertEqual(plan.mode, "repair")
        self.assertIn("checksums.json", plan.missing_assets)
        self.assertIn("SharpYuv-v1.6.0-alpha.1.xcframework.zip", plan.missing_assets)

    def test_plan_release_publication_uses_skip_mode_when_release_is_complete(self):
        module = load_spm_release_module()

        required_assets = module.required_release_asset_names(PACKAGE_TAG)
        plan = module.plan_release_publication(
            tag=PACKAGE_TAG,
            remote_tag_exists=True,
            release_asset_names=required_assets,
        )

        self.assertEqual(plan.mode, "skip")
        self.assertEqual(plan.missing_assets, ())

    def test_plan_release_publication_supports_stable_tags(self):
        module = load_spm_release_module()

        required_assets = module.required_release_asset_names(UPSTREAM_TAG)
        plan = module.plan_release_publication(
            tag=UPSTREAM_TAG,
            remote_tag_exists=True,
            release_asset_names=required_assets,
        )

        self.assertEqual(plan.mode, "skip")
        self.assertEqual(
            required_assets,
            (
                "WebP-v1.6.0.xcframework.zip",
                "WebPDecoder-v1.6.0.xcframework.zip",
                "WebPDemux-v1.6.0.xcframework.zip",
                "WebPMux-v1.6.0.xcframework.zip",
                "SharpYuv-v1.6.0.xcframework.zip",
                "checksums.json",
            ),
        )


class ReleaseCommandTests(unittest.TestCase):
    def test_command_render_package_swift_rejects_non_object_checksum_json(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            temp_path = Path(temp_dir)
            checksums_path = temp_path / "checksums.json"
            output_path = temp_path / "Package.swift"
            checksums_path.write_text('["not-a-dict"]', encoding="utf-8")

            result = subprocess.run(
                [
                    sys.executable,
                    str(MODULE_PATH),
                    "render-package-swift",
                    "--owner",
                    "SPMForge",
                    "--repository",
                    "libwebp",
                    "--tag",
                    PACKAGE_TAG,
                    "--checksums-json",
                    str(checksums_path),
                    "--output",
                    str(output_path),
                ],
                check=False,
                capture_output=True,
                text=True,
            )

            self.assertNotEqual(result.returncode, 0)
            self.assertRegex(result.stderr, "Checksum JSON must be an object")


class KeptXCFrameworkTests(unittest.TestCase):
    def test_build_xcframework_archives_keeps_symlinks_when_copying_unzipped_outputs(self):
        module = load_spm_release_module()

        with tempfile.TemporaryDirectory() as temp_dir:
            temp_path = Path(temp_dir)
            source_dir = temp_path / "source"
            output_dir = temp_path / "output"
            working_dir = temp_path / "work"
            source_dir.mkdir()
            output_dir.mkdir()

            kept_framework = (
                working_dir
                / "xcframeworks"
                / "WebP.xcframework"
                / "macos-arm64_x86_64"
                / "WebP.framework"
            )
            (kept_framework / "Versions" / "A" / "Resources").mkdir(parents=True)
            (kept_framework / "Versions" / "A" / "Resources" / "Info.plist").write_text(
                "plist\n",
                encoding="utf-8",
            )
            (kept_framework / "Versions" / "Current").symlink_to("A")
            (kept_framework / "Resources").symlink_to(Path("Versions") / "Current" / "Resources")

            with (
                mock.patch.object(module, "ensure_build_prerequisites"),
                mock.patch.object(module, "copy_source_tree", return_value=source_dir),
                mock.patch.object(module, "ensure_source_tree_is_buildable"),
                mock.patch.object(module, "prepare_header_directories", return_value={}),
                mock.patch.object(module, "build_archived_libraries", return_value={}),
                mock.patch.object(
                    module,
                    "create_xcframeworks",
                    return_value={"WebP": kept_framework.parents[1]},
                ),
                mock.patch.object(module, "validate_xcframeworks"),
                mock.patch.object(module, "verify_consumer_fixture"),
                mock.patch.object(
                    module,
                    "zip_xcframeworks",
                    return_value=[output_dir / "WebP-v1.6.0-alpha.1.xcframework.zip"],
                ),
            ):
                module.build_xcframework_archives(
                    source_dir=source_dir,
                    output_dir=output_dir,
                    tag=PACKAGE_TAG,
                    working_dir=working_dir,
                    keep_xcframeworks=True,
                )

            copied_link = (
                output_dir
                / "xcframeworks"
                / "WebP.xcframework"
                / "macos-arm64_x86_64"
                / "WebP.framework"
                / "Versions"
                / "Current"
            )
            self.assertTrue(copied_link.is_symlink())
            self.assertEqual(copied_link.readlink(), Path("A"))


class SourceTreeTests(unittest.TestCase):
    def test_copy_source_tree_reuses_existing_destination(self):
        module = load_spm_release_module()

        with tempfile.TemporaryDirectory() as temp_dir:
            temp_path = Path(temp_dir)
            source_dir = temp_path / "source-input"
            source_dir.mkdir()
            (source_dir / "CMakeLists.txt").write_text("cmake_minimum_required(VERSION 3.16)\n", encoding="utf-8")
            (source_dir / "keep.txt").write_text("fresh\n", encoding="utf-8")

            destination_dir = temp_path / "working"
            working_source = destination_dir / "source"
            working_source.mkdir(parents=True)
            (working_source / "stale.txt").write_text("stale\n", encoding="utf-8")

            copied_path = module.copy_source_tree(source_dir, destination_dir)

            self.assertEqual(copied_path, working_source)
            self.assertTrue((working_source / "CMakeLists.txt").exists())
            self.assertEqual((working_source / "keep.txt").read_text(encoding="utf-8"), "fresh\n")
            self.assertFalse((working_source / "stale.txt").exists())


class SourceAcquisitionTests(unittest.TestCase):
    def test_source_acquisition_config_file_exists(self):
        self.assertTrue(SOURCE_ACQUISITION_CONFIG_PATH.exists())

    def test_load_source_acquisition_config_uses_dynamic_fetch_wrapper_contract(self):
        module = load_spm_release_module()

        config = module.load_source_acquisition_config()

        self.assertEqual(config.strategy, "git-tag-export")
        self.assertEqual(config.upstream_repository_url, "https://github.com/webmproject/libwebp.git")
        self.assertEqual(config.upstream_tag_namespace, "refs/upstream-tags")
        self.assertEqual(config.upstream_tag_refspec, "refs/tags/*:refs/upstream-tags/*")
        self.assertEqual(config.source_snapshot_directory, "libwebp-source")

    def test_fetch_upstream_tags_updates_existing_remote_url_and_fetches_configured_refspec(self):
        module = load_spm_release_module()
        config = module.load_source_acquisition_config()

        with (
            mock.patch.object(module, "command_output", return_value="https://example.com/old.git"),
            mock.patch.object(module, "run_command") as run_command,
        ):
            module.fetch_upstream_tags(remote_name="upstream", config=config)

        self.assertEqual(
            run_command.call_args_list,
            [
                mock.call(
                    ["git", "remote", "set-url", "upstream", config.upstream_repository_url]
                ),
                mock.call(
                    ["git", "fetch", "--no-tags", "--force", "upstream", config.upstream_tag_refspec]
                ),
            ],
        )

    def test_fetch_upstream_tags_adds_remote_when_missing(self):
        module = load_spm_release_module()
        config = module.load_source_acquisition_config()

        with (
            mock.patch.object(module, "command_output", side_effect=RuntimeError("missing remote")),
            mock.patch.object(module, "run_command") as run_command,
        ):
            module.fetch_upstream_tags(remote_name="upstream", config=config)

        self.assertEqual(
            run_command.call_args_list,
            [
                mock.call(["git", "remote", "add", "upstream", config.upstream_repository_url]),
                mock.call(
                    ["git", "fetch", "--no-tags", "--force", "upstream", config.upstream_tag_refspec]
                ),
            ],
        )

    def test_latest_fetched_upstream_stable_tag_reads_configured_namespace(self):
        module = load_spm_release_module()
        config = module.load_source_acquisition_config()

        with mock.patch.object(
            module,
            "command_output",
            return_value="v1.5.0\nv1.6.0-rc1\nv1.6.0\n",
        ) as command_output:
            latest = module.latest_fetched_upstream_stable_tag(config)

        command_output.assert_called_once_with(
            ["git", "for-each-ref", "--format=%(refname:lstrip=2)", config.upstream_tag_namespace]
        )
        self.assertEqual(latest, "v1.6.0")

    def test_export_upstream_source_tree_uses_configured_namespace(self):
        module = load_spm_release_module()
        config = module.load_source_acquisition_config()

        with tempfile.TemporaryDirectory() as temp_dir:
            temp_path = Path(temp_dir)
            output_dir = temp_path / "source"

            with (
                mock.patch.object(module, "command_output") as command_output,
                mock.patch.object(module, "run_command") as run_command,
            ):
                exported_dir = module.export_upstream_source_tree(
                    tag=UPSTREAM_TAG,
                    output_dir=output_dir,
                    config=config,
                )

        archive_path = output_dir.resolve().parent / f".{UPSTREAM_TAG}.tar"
        self.assertEqual(exported_dir, output_dir.resolve())
        command_output.assert_called_once_with(
            ["git", "rev-parse", "--verify", "--quiet", "refs/upstream-tags/v1.6.0^{commit}"]
        )
        self.assertEqual(
            run_command.call_args_list,
            [
                mock.call(
                    [
                        "git",
                        "archive",
                        "--format=tar",
                        "--output",
                        str(archive_path),
                        "refs/upstream-tags/v1.6.0",
                    ]
                ),
                mock.call(["tar", "-xf", str(archive_path), "-C", str(output_dir.resolve())]),
            ],
        )


class HeaderLayoutTests(unittest.TestCase):
    def test_header_include_path_drops_src_prefix_for_webp_headers(self):
        module = load_spm_release_module()

        include_path = module.header_include_path("WebPDemux", "src/webp/demux.h")

        self.assertEqual(include_path, Path("webp/demux.h"))

    def test_header_include_path_preserves_non_src_roots(self):
        module = load_spm_release_module()

        include_path = module.header_include_path("SharpYuv", "sharpyuv/sharpyuv_csp.h")

        self.assertEqual(include_path, Path("sharpyuv/sharpyuv_csp.h"))

    def test_rewrite_public_header_text_uses_framework_style_include_for_webp_headers(self):
        module = load_spm_release_module()

        rewritten = module.rewrite_public_header_text(
            "WebP",
            "src/webp/decode.h",
            '#include "./types.h"\n',
        )

        self.assertEqual(rewritten, '#include <WebP/webp/types.h>\n')

    def test_rewrite_public_header_text_preserves_suffix_when_rewriting_same_framework_include(self):
        module = load_spm_release_module()

        rewritten = module.rewrite_public_header_text(
            "WebPDemux",
            "src/webp/demux.h",
            '#include "./decode.h"     // for WEBP_CSP_MODE\n',
        )

        self.assertEqual(
            rewritten,
            '#include <WebPDemux/webp/decode.h>     // for WEBP_CSP_MODE\n',
        )

    def test_rewrite_public_header_text_fixes_sharpyuv_self_include_for_framework_packaging(self):
        module = load_spm_release_module()

        rewritten = module.rewrite_public_header_text(
            "SharpYuv",
            "sharpyuv/sharpyuv_csp.h",
            '#include "sharpyuv/sharpyuv.h"\n',
        )

        self.assertEqual(rewritten, '#include <SharpYuv/sharpyuv/sharpyuv.h>\n')

    def test_rewrite_public_header_text_leaves_non_exported_include_unchanged(self):
        module = load_spm_release_module()

        rewritten = module.rewrite_public_header_text(
            "WebP",
            "src/webp/decode.h",
            '#include "private/internal.h"\n',
        )

        self.assertEqual(rewritten, '#include "private/internal.h"\n')

    def test_write_cmake_consumer_fixture_adds_framework_search_paths_for_nested_header_imports(self):
        module = load_spm_release_module()

        with tempfile.TemporaryDirectory() as temp_dir:
            temp_path = Path(temp_dir)
            xcframeworks: dict[str, Path] = {}
            for definition in module.ARTIFACT_DEFINITIONS:
                xcframework_path = temp_path / definition.xcframework_name
                (xcframework_path / "macos-arm64_x86_64").mkdir(parents=True)
                xcframeworks[definition.target_name] = xcframework_path

            def fake_run_command(*args, **kwargs):
                build_dir = temp_path / "consumer" / "build"
                build_dir.mkdir(parents=True, exist_ok=True)
                (build_dir / "spm_libwebp_consumer.xcodeproj").mkdir(exist_ok=True)

            with mock.patch.object(module, "run_command", side_effect=fake_run_command):
                module.write_cmake_consumer_fixture(temp_path / "consumer", xcframeworks)

            cmake_contents = (temp_path / "consumer" / "CMakeLists.txt").read_text(
                encoding="utf-8"
            )

        self.assertIn('target_compile_options(SmokeWebP PRIVATE "-F', cmake_contents)
        self.assertIn(
            f'-F{module.cmake_quote(str(xcframeworks["WebP"] / "macos-arm64_x86_64"))}',
            cmake_contents,
        )
        self.assertIn(
            f'-F{module.cmake_quote(str(xcframeworks["SharpYuv"] / "macos-arm64_x86_64"))}',
            cmake_contents,
        )

    def test_assemble_framework_bundle_rewrites_all_direct_linked_binary_dependencies(self):
        module = load_spm_release_module()
        definition = module.artifact_definition_by_name("WebPDemux")
        platform_group = next(group for group in module.PLATFORM_GROUPS if group.identifier == "macos")

        with tempfile.TemporaryDirectory() as temp_dir:
            temp_path = Path(temp_dir)
            headers_root = temp_path / "headers"
            headers_root.mkdir()
            (headers_root / "placeholder.h").write_text("// header\n", encoding="utf-8")
            built_binary = temp_path / "libwebpdemux.dylib"
            built_binary.write_text("binary\n", encoding="utf-8")
            built_slice = module.BuiltSlice(
                platform_group=platform_group,
                archive_path=temp_path / "archive.xcarchive",
                binary_path=built_binary,
            )

            with (
                mock.patch.object(module, "run_command") as run_command,
                mock.patch.object(
                    module,
                    "linked_install_name",
                    side_effect=[
                        "@rpath/libwebp.7.dylib",
                        "@rpath/libsharpyuv.0.dylib",
                    ],
                ),
            ):
                module.assemble_framework_bundle(
                    temp_path / "frameworks",
                    definition=definition,
                    built_slice=built_slice,
                    headers_root=headers_root,
                )

        self.assertEqual(
            run_command.call_args_list,
            [
                mock.call(
                    [
                        "install_name_tool",
                        "-id",
                        "@rpath/WebPDemux.framework/Versions/A/WebPDemux",
                        mock.ANY,
                    ]
                ),
                mock.call(
                    [
                        "install_name_tool",
                        "-change",
                        "@rpath/libwebp.7.dylib",
                        "@rpath/WebP.framework/Versions/A/WebP",
                        mock.ANY,
                    ]
                ),
                mock.call(
                    [
                        "install_name_tool",
                        "-change",
                        "@rpath/libsharpyuv.0.dylib",
                        "@rpath/SharpYuv.framework/Versions/A/SharpYuv",
                        mock.ANY,
                    ]
                ),
            ],
        )

    def test_assemble_framework_bundle_uses_versioned_layout_for_macos(self):
        module = load_spm_release_module()
        definition = module.artifact_definition_by_name("WebP")
        platform_group = next(group for group in module.PLATFORM_GROUPS if group.identifier == "macos")

        with tempfile.TemporaryDirectory() as temp_dir:
            temp_path = Path(temp_dir)
            headers_root = temp_path / "headers"
            webp_headers = headers_root / "webp"
            webp_headers.mkdir(parents=True)
            (webp_headers / "decode.h").write_text("// decode\n", encoding="utf-8")
            (webp_headers / "encode.h").write_text("// encode\n", encoding="utf-8")
            (webp_headers / "types.h").write_text("// types\n", encoding="utf-8")
            built_binary = temp_path / "libwebp.dylib"
            built_binary.write_text("binary\n", encoding="utf-8")
            built_slice = module.BuiltSlice(
                platform_group=platform_group,
                archive_path=temp_path / "archive.xcarchive",
                binary_path=built_binary,
            )

            with (
                mock.patch.object(module, "run_command"),
                mock.patch.object(module, "linked_install_name", return_value="@rpath/libsharpyuv.0.dylib"),
            ):
                framework_dir = module.assemble_framework_bundle(
                    temp_path / "frameworks",
                    definition=definition,
                    built_slice=built_slice,
                    headers_root=headers_root,
                )

            current_dir = framework_dir / "Versions" / "Current"
            self.assertTrue(current_dir.is_symlink())
            self.assertEqual(current_dir.resolve(), (framework_dir / "Versions" / "A").resolve())
            self.assertTrue((framework_dir / "WebP").is_symlink())
            self.assertEqual(
                (framework_dir / "WebP").resolve(),
                (framework_dir / "Versions" / "A" / "WebP").resolve(),
            )
            self.assertTrue((framework_dir / "Headers").is_symlink())
            self.assertEqual(
                (framework_dir / "Headers").resolve(),
                (framework_dir / "Versions" / "A" / "Headers").resolve(),
            )
            self.assertTrue((framework_dir / "Modules").is_symlink())
            self.assertEqual(
                (framework_dir / "Modules").resolve(),
                (framework_dir / "Versions" / "A" / "Modules").resolve(),
            )
            self.assertTrue((framework_dir / "Resources").is_symlink())
            self.assertEqual(
                (framework_dir / "Resources").resolve(),
                (framework_dir / "Versions" / "A" / "Resources").resolve(),
            )
            self.assertTrue((framework_dir / "Versions" / "A" / "Resources" / "Info.plist").exists())
            self.assertTrue((framework_dir / "Versions" / "A" / "Modules" / "module.modulemap").exists())
            self.assertTrue((framework_dir / "Versions" / "A" / "Headers" / "webp" / "decode.h").exists())

    def test_assemble_framework_bundle_uses_versioned_install_name_for_macos(self):
        module = load_spm_release_module()
        definition = module.artifact_definition_by_name("WebP")
        platform_group = next(group for group in module.PLATFORM_GROUPS if group.identifier == "macos")

        with tempfile.TemporaryDirectory() as temp_dir:
            temp_path = Path(temp_dir)
            headers_root = temp_path / "headers"
            headers_root.mkdir()
            built_binary = temp_path / "libwebp.dylib"
            built_binary.write_text("binary\n", encoding="utf-8")
            built_slice = module.BuiltSlice(
                platform_group=platform_group,
                archive_path=temp_path / "archive.xcarchive",
                binary_path=built_binary,
            )

            with (
                mock.patch.object(module, "run_command") as run_command,
                mock.patch.object(module, "linked_install_name", return_value="@rpath/libsharpyuv.0.dylib"),
            ):
                module.assemble_framework_bundle(
                    temp_path / "frameworks",
                    definition=definition,
                    built_slice=built_slice,
                    headers_root=headers_root,
                )

        self.assertEqual(
            run_command.call_args_list[0],
            mock.call(
                [
                    "install_name_tool",
                    "-id",
                    "@rpath/WebP.framework/Versions/A/WebP",
                    mock.ANY,
                ]
            ),
        )

    def test_validate_framework_bundle_layout_rejects_shallow_macos_bundle(self):
        module = load_spm_release_module()
        platform_group = next(group for group in module.PLATFORM_GROUPS if group.identifier == "macos")

        with tempfile.TemporaryDirectory() as temp_dir:
            framework_dir = Path(temp_dir) / "WebP.framework"
            framework_dir.mkdir()
            (framework_dir / "Info.plist").write_text("plist\n", encoding="utf-8")

            with self.assertRaisesRegex(RuntimeError, "versioned layout"):
                module.validate_framework_bundle_layout(
                    framework_dir,
                    target_name="WebP",
                    platform_group=platform_group,
                )


class SwiftPMFixtureTests(unittest.TestCase):
    def test_render_local_binary_package_swift_uses_path_based_binary_targets(self):
        module = load_spm_release_module()

        package_swift = module.render_local_binary_package_swift(
            package_name="LocalLibWebPBinary",
            xcframework_paths={
                definition.target_name: Path(f"Artifacts/{definition.target_name}.xcframework")
                for definition in module.ARTIFACT_DEFINITIONS
            },
        )

        self.assertIn('name: "LocalLibWebPBinary"', package_swift)
        self.assertIn('.library(name: "WebP", targets: ["WebP", "SharpYuv"])', package_swift)
        self.assertIn(
            '.library(name: "WebPDemux", targets: ["WebPDemux", "WebP", "SharpYuv"])',
            package_swift,
        )
        self.assertIn(
            '.library(name: "WebPMux", targets: ["WebPMux", "WebP", "SharpYuv"])',
            package_swift,
        )
        self.assertIn('path: "Artifacts/WebP.xcframework"', package_swift)
        self.assertNotIn('url: "https://github.com/', package_swift)

    def test_render_spm_consumer_package_swift_depends_on_all_binary_products(self):
        module = load_spm_release_module()

        package_swift = module.render_spm_consumer_package_swift(
            binary_package_name="LocalLibWebPBinary",
            binary_package_path="../LocalLibWebPBinary",
        )

        self.assertIn('name: "libwebp-consumer"', package_swift)
        self.assertIn('.package(name: "LocalLibWebPBinary", path: "../LocalLibWebPBinary")', package_swift)
        self.assertIn('.product(name: "WebP", package: "LocalLibWebPBinary")', package_swift)
        self.assertIn('.product(name: "WebPMux", package: "LocalLibWebPBinary")', package_swift)
        self.assertIn('.product(name: "SharpYuv", package: "LocalLibWebPBinary")', package_swift)

    def test_render_spm_consumer_sources_create_one_probe_per_public_module(self):
        module = load_spm_release_module()

        sources = module.render_spm_consumer_sources()

        self.assertEqual(
            sorted(sources),
            [
                "App.swift",
                "SharpYuvProbe.swift",
                "WebPDecoderProbe.swift",
                "WebPDemuxProbe.swift",
                "WebPMuxProbe.swift",
                "WebPProbe.swift",
            ],
        )
        self.assertIn("@main", sources["App.swift"])
        self.assertIn("runWebPProbe()", sources["App.swift"])
        self.assertIn("runSharpYuvProbe()", sources["App.swift"])
        self.assertIn("import WebP", sources["WebPProbe.swift"])
        self.assertIn("WebPGetEncoderVersion()", sources["WebPProbe.swift"])
        self.assertIn("import WebPDecoder", sources["WebPDecoderProbe.swift"])
        self.assertIn("WebPGetDecoderVersion()", sources["WebPDecoderProbe.swift"])
        self.assertIn("import WebPDemux", sources["WebPDemuxProbe.swift"])
        self.assertIn("WebPDemuxGetI(nil, WEBP_FF_CANVAS_WIDTH)", sources["WebPDemuxProbe.swift"])
        self.assertIn("import WebPMux", sources["WebPMuxProbe.swift"])
        self.assertIn("WebPMuxNew()", sources["WebPMuxProbe.swift"])
        self.assertIn("import SharpYuv", sources["SharpYuvProbe.swift"])
        self.assertIn("SharpYuvGetVersion()", sources["SharpYuvProbe.swift"])


class BuildPlanTests(unittest.TestCase):
    def test_build_script_print_plan_covers_all_apple_platform_groups(self):
        if not BUILD_SCRIPT_PATH.exists():
            raise AssertionError(f"missing build script: {BUILD_SCRIPT_PATH}")

        result = subprocess.run(
            [str(BUILD_SCRIPT_PATH), "--print-build-plan"],
            check=False,
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0, msg=result.stderr)

        plan = json.loads(result.stdout)
        group_names = [group["name"] for group in plan["platform_groups"]]

        self.assertEqual(
            group_names,
            [
                "iOS",
                "iOS Simulator",
                "macOS",
                "Mac Catalyst",
                "tvOS",
                "tvOS Simulator",
                "watchOS",
                "watchOS Simulator",
                "visionOS",
                "visionOS Simulator",
            ],
        )

        watchos_group = next(
            group for group in plan["platform_groups"] if group["name"] == "watchOS"
        )
        self.assertEqual(watchos_group["architectures"], ["arm64", "arm64_32"])
        self.assertEqual(watchos_group["cmake_architectures"], "arm64;arm64_32")


class CMakeConfigurationTests(unittest.TestCase):
    def test_platform_specific_cmake_args_pin_universal_architectures(self):
        module = load_spm_release_module()

        ios_simulator = next(
            group for group in module.PLATFORM_GROUPS if group.identifier == "ios-simulator"
        )
        arguments = module.cmake_configuration_args_for_platform_group(ios_simulator)

        self.assertIn("-DCMAKE_OSX_ARCHITECTURES=arm64;x86_64", arguments)
        self.assertIn("-DCMAKE_OSX_SYSROOT=iphonesimulator", arguments)
        self.assertIn("-DCMAKE_OSX_DEPLOYMENT_TARGET=13.0", arguments)
        self.assertIn("-DCMAKE_SYSTEM_NAME=iOS", arguments)
        self.assertIn("-DCMAKE_XCODE_ATTRIBUTE_SUPPORTS_MACCATALYST=NO", arguments)
        self.assertEqual(ios_simulator.destination, "generic/platform=iOS Simulator")

    def test_single_arch_platforms_still_configure_explicit_cmake_architectures(self):
        module = load_spm_release_module()

        ios_device = next(group for group in module.PLATFORM_GROUPS if group.identifier == "ios")
        arguments = module.cmake_configuration_args_for_platform_group(ios_device)

        self.assertIn("-DCMAKE_OSX_ARCHITECTURES=arm64", arguments)
        self.assertIn("-DCMAKE_OSX_SYSROOT=iphoneos", arguments)
        self.assertIn("-DCMAKE_OSX_DEPLOYMENT_TARGET=13.0", arguments)
        self.assertIn("-DCMAKE_SYSTEM_NAME=iOS", arguments)
        self.assertIn("-DCMAKE_XCODE_ATTRIBUTE_SUPPORTS_MACCATALYST=NO", arguments)
        self.assertEqual(ios_device.destination, "generic/platform=iOS")

    def test_watchos_configures_with_universal_architectures_and_cross_compile_sysroot(self):
        module = load_spm_release_module()

        watchos = next(group for group in module.PLATFORM_GROUPS if group.identifier == "watchos")
        arguments = module.cmake_configuration_args_for_platform_group(watchos)

        self.assertEqual(watchos.architectures, ("arm64", "arm64_32"))
        self.assertIn("-DCMAKE_OSX_ARCHITECTURES=arm64;arm64_32", arguments)
        self.assertIn("-DCMAKE_OSX_SYSROOT=watchos", arguments)
        self.assertIn("-DCMAKE_OSX_DEPLOYMENT_TARGET=8.0", arguments)
        self.assertIn("-DCMAKE_SYSTEM_NAME=watchOS", arguments)
        self.assertIn("-DCMAKE_XCODE_ATTRIBUTE_SUPPORTS_MACCATALYST=NO", arguments)
        self.assertEqual(watchos.destination, "generic/platform=watchOS")

    def test_mac_catalyst_only_enables_supports_maccatalyst_for_catalyst_slice(self):
        module = load_spm_release_module()

        mac_catalyst = next(
            group for group in module.PLATFORM_GROUPS if group.identifier == "mac-catalyst"
        )
        arguments = module.cmake_configuration_args_for_platform_group(mac_catalyst)

        self.assertIn("-DCMAKE_XCODE_ATTRIBUTE_SUPPORTS_MACCATALYST=YES", arguments)
        self.assertNotIn("-DCMAKE_SYSTEM_NAME=iOS", arguments)
        self.assertEqual(mac_catalyst.destination, "generic/platform=macOS,variant=Mac Catalyst")

    def test_xcode_ccache_wrapper_scripts_are_executable_and_dispatch_through_xcrun(self):
        module = load_spm_release_module()

        with tempfile.TemporaryDirectory() as temp_dir:
            wrappers = module.create_xcode_ccache_wrappers(Path(temp_dir))

            self.assertTrue(wrappers.cc.exists())
            self.assertTrue(wrappers.cxx.exists())
            self.assertTrue(wrappers.cc.stat().st_mode & 0o111)
            self.assertTrue(wrappers.cxx.stat().st_mode & 0o111)
            self.assertIn('exec ccache "$(xcrun --find clang)" "$@"', wrappers.cc.read_text(encoding="utf-8"))
            self.assertIn(
                'exec ccache "$(xcrun --find clang++)" "$@"',
                wrappers.cxx.read_text(encoding="utf-8"),
            )

    def test_cmake_configuration_args_can_pin_xcode_compiler_wrapper_paths(self):
        module = load_spm_release_module()

        ios_device = next(group for group in module.PLATFORM_GROUPS if group.identifier == "ios")
        compiler_wrappers = module.CompilerWrapperPaths(
            cc=Path("/tmp/ccache-clang"),
            cxx=Path("/tmp/ccache-clang++"),
        )

        arguments = module.cmake_configuration_args_for_platform_group(
            ios_device,
            compiler_wrappers=compiler_wrappers,
        )

        self.assertIn("-DCMAKE_XCODE_ATTRIBUTE_CC=/tmp/ccache-clang", arguments)
        self.assertIn("-DCMAKE_XCODE_ATTRIBUTE_CXX=/tmp/ccache-clang++", arguments)


class BuildArchiveTests(unittest.TestCase):
    def test_assert_destination_available_accepts_matching_available_destination(self):
        module = load_spm_release_module()

        watchos = next(group for group in module.PLATFORM_GROUPS if group.identifier == "watchos")

        with mock.patch.object(
            module,
            "command_output",
            return_value=(
                '\n\tAvailable destinations for the "webp" scheme:\n'
                "\t\t{ platform:watchOS, id:dvtdevice-DVTiOSDevicePlaceholder-watchos:placeholder, name:Any watchOS Device }\n"
            ),
        ):
            module.assert_destination_available(
                project_path=Path("/tmp/WebP.xcodeproj"),
                scheme="webp",
                platform_group=watchos,
            )

    def test_assert_destination_available_fails_fast_on_ineligible_destination(self):
        module = load_spm_release_module()

        watchos = next(group for group in module.PLATFORM_GROUPS if group.identifier == "watchos")

        with mock.patch.object(
            module,
            "command_output",
            return_value=(
                '\n\tAvailable destinations for the "webp" scheme:\n'
                "\t\t{ platform:macOS, variant:Mac Catalyst, name:Any Mac }\n\n"
                '\tIneligible destinations for the "webp" scheme:\n'
                "\t\t{ platform:watchOS, id:dvtdevice-DVTiOSDevicePlaceholder-watchos:placeholder, name:Any watchOS Device, error:watchOS 26.4 is not installed. }\n"
            ),
        ):
            with self.assertRaisesRegex(RuntimeError, "xcodebuild -downloadPlatform watchOS"):
                module.assert_destination_available(
                    project_path=Path("/tmp/WebP.xcodeproj"),
                    scheme="webp",
                    platform_group=watchos,
                )

    def test_build_archive_uses_explicit_destination_and_validates_platform_metadata(self):
        module = load_spm_release_module()

        artifact_definition = next(
            definition for definition in module.ARTIFACT_DEFINITIONS if definition.target_name == "WebP"
        )
        watchos = next(group for group in module.PLATFORM_GROUPS if group.identifier == "watchos")

        with tempfile.TemporaryDirectory() as temp_dir:
            temp_path = Path(temp_dir)
            project_path = temp_path / "WebP.xcodeproj"
            project_path.touch()
            binary_path = temp_path / "libwebp.dylib"
            binary_path.touch()

            with (
                mock.patch.object(module, "run_command") as run_command,
                mock.patch.object(module, "find_built_dynamic_library", return_value=binary_path),
                mock.patch.object(module, "validate_binary_platform") as validate_binary_platform,
                mock.patch.object(module, "assert_destination_available") as assert_destination_available,
            ):
                built_slice = module.build_archive_for_slice(
                    project_path=project_path,
                    artifact_definition=artifact_definition,
                    platform_group=watchos,
                    archives_root=temp_path / "archives",
                )

        arguments = run_command.call_args.args[0]
        self.assertIn("-destination", arguments)
        self.assertIn("generic/platform=watchOS", arguments)
        assert_destination_available.assert_called_once_with(
            project_path=project_path,
            scheme=artifact_definition.cmake_target,
            platform_group=watchos,
        )
        validate_binary_platform.assert_called_once_with(
            binary_path,
            watchos.expected_vtool_platform,
        )
        self.assertEqual(built_slice.binary_path, binary_path)


class WorkflowTopologyTests(unittest.TestCase):
    def test_publish_latest_workflow_uses_shared_publish_core(self):
        workflow_body = PUBLISH_LATEST_WORKFLOW_PATH.read_text(encoding="utf-8")

        self.assertIn("uses: ./.github/workflows/publish-package-release-core.yml", workflow_body)
        self.assertIn("selection_mode: latest", workflow_body)
        self.assertIn("release_channel: alpha", workflow_body)
        self.assertIn("publish_to_main: true", workflow_body)

    def test_manual_publish_workflow_uses_shared_publish_core(self):
        workflow_body = PUBLISH_MANUAL_WORKFLOW_PATH.read_text(encoding="utf-8")

        self.assertIn("uses: ./.github/workflows/publish-package-release-core.yml", workflow_body)
        self.assertIn("selection_mode: requested", workflow_body)
        self.assertIn("release_channel: ${{ inputs.release_channel }}", workflow_body)
        self.assertIn("publish_to_main: ${{ inputs.publish_to_main }}", workflow_body)

    def test_shared_publish_core_workflow_exists_with_expected_inputs(self):
        workflow_body = PUBLISH_CORE_WORKFLOW_PATH.read_text(encoding="utf-8")

        self.assertIn("workflow_call:", workflow_body)
        self.assertIn("selection_mode:", workflow_body)
        self.assertIn("upstream_tag:", workflow_body)
        self.assertIn("release_channel:", workflow_body)
        self.assertIn("publish_to_main:", workflow_body)
        self.assertIn("python3 scripts/spm_release.py fetch-upstream-tags --remote upstream", workflow_body)
        self.assertIn("python3 scripts/spm_release.py export-upstream-source", workflow_body)
        self.assertIn('SPM_RELEASE_ENABLE_CCACHE: "1"', workflow_body)
        self.assertIn("CCACHE_KEY_SCHEMA: v2", workflow_body)
        self.assertIn("uses: actions/cache/restore@v4", workflow_body)
        self.assertIn("uses: actions/cache/save@v4", workflow_body)
        self.assertIn("path: ${{ github.workspace }}/.ccache", workflow_body)
        self.assertIn("steps.release_tag.outputs.upstream_commit", workflow_body)
        self.assertIn("libwebp-ccache-${{ env.CCACHE_KEY_SCHEMA }}", workflow_body)
        self.assertIn('echo "CCACHE_BASEDIR=${RUNNER_TEMP}" >> "${GITHUB_ENV}"', workflow_body)
        self.assertNotIn("CCACHE_BASEDIR: ${{ runner.temp }}", workflow_body)
        self.assertIn("ccache --show-stats", workflow_body)
        self.assertIn('--working-dir "${RUNNER_TEMP}/xcframework-build"', workflow_body)
        self.assertIn("inspect_release_state", workflow_body)
        self.assertIn('gh api "repos/${GITHUB_REPOSITORY}/releases/latest" --jq \'.tag_name\'', workflow_body)
        self.assertIn('if [[ "${mode}" == "skip" && "${metadata_needs_repair}" == "true" ]]; then', workflow_body)
        self.assertIn('release_args+=(--prerelease --latest=false)', workflow_body)
        self.assertIn('gh api --method PATCH "repos/${GITHUB_REPOSITORY}/releases/${release_id}"', workflow_body)
        self.assertIn("-F make_latest=false", workflow_body)
        self.assertIn("-F prerelease=true", workflow_body)
        self.assertIn("-F prerelease=false", workflow_body)
        self.assertNotIn("https://github.com/webmproject/libwebp.git", workflow_body)

    def test_validate_workflow_checks_rendered_package_contract(self):
        workflow_body = VALIDATE_WORKFLOW_PATH.read_text(encoding="utf-8")

        self.assertIn("python3 scripts/spm_release.py compute-checksums", workflow_body)
        self.assertIn("python3 scripts/spm_release.py render-package-swift", workflow_body)
        self.assertIn("swift package dump-package --package-path", workflow_body)

    def test_validate_workflow_accepts_optional_upstream_tag_input(self):
        workflow_body = VALIDATE_WORKFLOW_PATH.read_text(encoding="utf-8")

        self.assertIn("workflow_dispatch:", workflow_body)
        self.assertIn("inputs:", workflow_body)
        self.assertIn("upstream_tag:", workflow_body)
        self.assertIn("Optional stable upstream tag to validate", workflow_body)

    def test_validate_workflow_supports_requested_or_latest_upstream_tag_resolution(self):
        workflow_body = VALIDATE_WORKFLOW_PATH.read_text(encoding="utf-8")

        self.assertIn('requested_upstream_tag="${{ inputs.upstream_tag }}"', workflow_body)
        self.assertIn('if [[ -n "${requested_upstream_tag}" ]]; then', workflow_body)
        self.assertIn(
            'upstream_tag="$(python3 scripts/spm_release.py assert-stable-tag --tag "${requested_upstream_tag}")"',
            workflow_body,
        )
        self.assertIn(
            'upstream_tag="$(python3 scripts/spm_release.py latest-fetched-upstream-stable-tag)"',
            workflow_body,
        )
        self.assertIn('upstream_commit="$(git rev-parse "refs/upstream-tags/${upstream_tag}^{commit}")"', workflow_body)
        self.assertIn("python3 scripts/spm_release.py fetch-upstream-tags --remote upstream", workflow_body)
        self.assertIn("python3 scripts/spm_release.py export-upstream-source", workflow_body)
        self.assertIn('SPM_RELEASE_ENABLE_CCACHE: "1"', workflow_body)
        self.assertIn("CCACHE_KEY_SCHEMA: v2", workflow_body)
        self.assertIn("uses: actions/cache/restore@v4", workflow_body)
        self.assertIn("uses: actions/cache/save@v4", workflow_body)
        self.assertIn("path: ${{ github.workspace }}/.ccache", workflow_body)
        self.assertIn("steps.release_tag.outputs.upstream_commit", workflow_body)
        self.assertIn("libwebp-ccache-${{ env.CCACHE_KEY_SCHEMA }}", workflow_body)
        self.assertIn('echo "CCACHE_BASEDIR=${RUNNER_TEMP}" >> "${GITHUB_ENV}"', workflow_body)
        self.assertNotIn("CCACHE_BASEDIR: ${{ runner.temp }}", workflow_body)
        self.assertIn("ccache --show-stats", workflow_body)
        self.assertIn('--working-dir "${RUNNER_TEMP}/xcframework-build"', workflow_body)
        self.assertNotIn("https://github.com/webmproject/libwebp.git", workflow_body)

if __name__ == "__main__":
    unittest.main()

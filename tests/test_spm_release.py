import importlib.util
import json
import subprocess
import sys
import tempfile
import unittest
from unittest import mock
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
MODULE_PATH = REPO_ROOT / "scripts" / "spm_release.py"
BUILD_SCRIPT_PATH = REPO_ROOT / "scripts" / "build_apple_xcframeworks.sh"


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


class ReleaseArtifactTests(unittest.TestCase):
    def test_release_artifacts_are_versioned_xcframework_archives(self):
        module = load_spm_release_module()

        artifacts = module.release_artifacts_for_tag("v1.6.0")
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

        artifacts = module.release_artifacts_for_tag("v1.6.0")
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

    def test_render_package_swift_uses_release_asset_download_urls(self):
        module = load_spm_release_module()

        package_swift = module.render_package_swift(
            owner="RbBtSn0w",
            repository="spm-libwebp",
            tag="v1.6.0",
            checksums={
                "WebP": "1" * 64,
                "WebPDecoder": "2" * 64,
                "WebPDemux": "3" * 64,
                "WebPMux": "4" * 64,
                "SharpYuv": "5" * 64,
            },
        )

        self.assertIn('.library(name: "WebP", targets: ["WebP"])', package_swift)
        self.assertIn('.library(name: "WebPDemux", targets: ["WebPDemux", "WebP"])', package_swift)
        self.assertIn('.library(name: "WebPMux", targets: ["WebPMux", "WebP"])', package_swift)
        self.assertIn(
            'url: "https://github.com/RbBtSn0w/spm-libwebp/releases/download/v1.6.0/WebP-v1.6.0.xcframework.zip"',
            package_swift,
        )
        self.assertIn('checksum: "' + ("1" * 64) + '"', package_swift)

    def test_render_package_swift_fails_fast_on_missing_checksum(self):
        module = load_spm_release_module()

        with self.assertRaisesRegex(ValueError, "Missing checksum"):
            module.render_package_swift(
                owner="RbBtSn0w",
                repository="spm-libwebp",
                tag="v1.6.0",
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
            module.required_release_asset_names("v1.6.0"),
            (
                "WebP-v1.6.0.xcframework.zip",
                "WebPDecoder-v1.6.0.xcframework.zip",
                "WebPDemux-v1.6.0.xcframework.zip",
                "WebPMux-v1.6.0.xcframework.zip",
                "SharpYuv-v1.6.0.xcframework.zip",
                "checksums.json",
            ),
        )

    def test_plan_release_publication_uses_fresh_mode_for_new_tags(self):
        module = load_spm_release_module()

        plan = module.plan_release_publication(
            tag="v1.6.0",
            remote_tag_exists=False,
            release_asset_names=(),
        )

        self.assertEqual(plan.mode, "fresh")
        self.assertEqual(plan.missing_assets, module.required_release_asset_names("v1.6.0"))

    def test_plan_release_publication_uses_repair_mode_when_assets_are_missing(self):
        module = load_spm_release_module()

        plan = module.plan_release_publication(
            tag="v1.6.0",
            remote_tag_exists=True,
            release_asset_names=("WebP-v1.6.0.xcframework.zip",),
        )

        self.assertEqual(plan.mode, "repair")
        self.assertIn("checksums.json", plan.missing_assets)
        self.assertIn("SharpYuv-v1.6.0.xcframework.zip", plan.missing_assets)

    def test_plan_release_publication_uses_skip_mode_when_release_is_complete(self):
        module = load_spm_release_module()

        required_assets = module.required_release_asset_names("v1.6.0")
        plan = module.plan_release_publication(
            tag="v1.6.0",
            remote_tag_exists=True,
            release_asset_names=required_assets,
        )

        self.assertEqual(plan.mode, "skip")
        self.assertEqual(plan.missing_assets, ())


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
                    "v1.6.0",
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


class HeaderLayoutTests(unittest.TestCase):
    def test_header_include_path_drops_src_prefix_for_webp_headers(self):
        module = load_spm_release_module()

        include_path = module.header_include_path("WebPDemux", "src/webp/demux.h")

        self.assertEqual(include_path, Path("webp/demux.h"))

    def test_header_include_path_preserves_non_src_roots(self):
        module = load_spm_release_module()

        include_path = module.header_include_path("SharpYuv", "sharpyuv/sharpyuv_csp.h")

        self.assertEqual(include_path, Path("sharpyuv/sharpyuv_csp.h"))

    def test_rewrite_public_header_text_fixes_sharpyuv_self_include_for_framework_packaging(self):
        module = load_spm_release_module()

        rewritten = module.rewrite_public_header_text(
            "SharpYuv",
            "sharpyuv/sharpyuv_csp.h",
            '#include "sharpyuv/sharpyuv.h"\n',
        )

        self.assertEqual(rewritten, '#include "./sharpyuv.h"\n')


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
        self.assertIn('.library(name: "WebPDemux", targets: ["WebPDemux", "WebP"])', package_swift)
        self.assertIn('.library(name: "WebPMux", targets: ["WebPMux", "WebP"])', package_swift)
        self.assertIn('path: "Artifacts/WebP.xcframework"', package_swift)
        self.assertNotIn('url: "https://github.com/', package_swift)

    def test_render_spm_consumer_package_swift_depends_on_all_binary_products(self):
        module = load_spm_release_module()

        package_swift = module.render_spm_consumer_package_swift(
            binary_package_name="LocalLibWebPBinary",
            binary_package_path="../LocalLibWebPBinary",
        )

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

if __name__ == "__main__":
    unittest.main()

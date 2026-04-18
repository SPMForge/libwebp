import importlib.util
import json
import subprocess
import sys
import unittest
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


if __name__ == "__main__":
    unittest.main()

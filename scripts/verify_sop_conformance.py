#!/usr/bin/env python3
from __future__ import annotations

import json
import re
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
WORKFLOWS_DIR = REPO_ROOT / ".github" / "workflows"


def require(condition: bool, message: str) -> None:
    if not condition:
        raise SystemExit(message)


def require_regex(pattern: str, text: str, message: str) -> None:
    require(re.search(pattern, text, re.MULTILINE) is not None, message)


def read_text(path: Path) -> str:
    require(path.exists(), f"missing file: {path}")
    return path.read_text(encoding="utf-8")


def main() -> int:
    readme = read_text(REPO_ROOT / "README.md")
    package_swift = read_text(REPO_ROOT / "Package.swift")
    publish_core = read_text(WORKFLOWS_DIR / "publish-package-release-core.yml")
    validate_workflow = read_text(WORKFLOWS_DIR / "validate-apple-release-pipeline.yml")

    require("packaging wrapper" in readme, "README must describe the repo as a packaging wrapper")
    require("shared" in readme and "publish-package-release-core" in readme, "README must describe the shared publish core")
    require("config/platforms.json" in readme, "README must point to config/platforms.json as deployment target source")
    require("poisoned empty cache snapshots" in readme, "README must document compiler-cache empty-snapshot prevention")
    require("cache-schema bump" in readme, "README must document compiler-cache key rotation for poisoned cache lines")
    require("workflow_call:" in publish_core, "publish core must be reusable via workflow_call")
    require("--latest=false" in publish_core, "alpha publishes must force latest=false")
    require("resolve:" in publish_core and "build:" in publish_core and "publish:" in publish_core, "publish core must isolate resolve, build, and publish jobs")
    require(
        publish_core.count("python3 scripts/spm_release.py fetch-upstream-tags --remote upstream") >= 2,
        "publish core must fetch upstream tag refs in every job that consumes refs/upstream-tags",
    )
    require_regex(r"actions/checkout@v([6-9]|[1-9][0-9]+)", publish_core, "publish core must use a Node 24-ready checkout action")
    require_regex(r"actions/setup-python@v([6-9]|[1-9][0-9]+)", publish_core, "publish core must use a Node 24-ready setup-python action")
    require_regex(r"actions/cache/restore@v([5-9]|[1-9][0-9]+)", publish_core, "publish core must use a Node 24-ready cache restore action")
    require_regex(r"actions/cache/save@v([5-9]|[1-9][0-9]+)", publish_core, "publish core must use a Node 24-ready cache save action")
    require_regex(r"actions/upload-artifact@v([6-9]|[1-9][0-9]+)", publish_core, "publish core must upload build outputs with a Node 24-ready artifact action")
    require_regex(r"actions/download-artifact@v([5-9]|[1-9][0-9]+)", publish_core, "publish core must download build outputs with a Node 24-ready artifact action")
    require("id: build_artifacts" in publish_core, "publish core must identify the compile-heavy build step for cache-save gating")
    require("id: cache_payload" in publish_core, "publish core must inspect compiler cache payload before saving")
    require("steps.restore_ccache.conclusion == 'success'" in publish_core, "publish core must only save compiler cache after a successful restore step")
    require("steps.build_artifacts.conclusion == 'success'" in publish_core, "publish core must only save compiler cache after a successful compile-heavy build step")
    require("steps.cache_payload.outputs.save_ready == 'true'" in publish_core, "publish core must require a non-empty compiler cache payload before saving")
    require("steps.restore_ccache.outputs.cache-hit != 'true'" in publish_core, "publish core must skip cache save after an exact cache hit")
    require("package-build-bundle-${{ github.run_id }}" in publish_core, "publish core must use a stable build bundle artifact name within a workflow run")
    require("package-build-bundle-${{ github.run_id }}-${{ github.run_attempt }}" not in publish_core, "publish core must not key build bundle artifacts on run_attempt")
    require("overwrite: true" in publish_core, "publish core must overwrite the stable build bundle artifact when build reruns")
    require("prepare-release-publication" in publish_core, "publish core must delegate publication planning to repo-local Python")
    require("push:" in validate_workflow and "pull_request:" in validate_workflow, "validation workflow must run on push and pull_request")
    require_regex(r"actions/checkout@v([6-9]|[1-9][0-9]+)", validate_workflow, "validation workflow must use a Node 24-ready checkout action")
    require_regex(r"actions/setup-python@v([6-9]|[1-9][0-9]+)", validate_workflow, "validation workflow must use a Node 24-ready setup-python action")
    require_regex(r"actions/cache/restore@v([5-9]|[1-9][0-9]+)", validate_workflow, "validation workflow must use a Node 24-ready cache restore action")
    require_regex(r"actions/cache/save@v([5-9]|[1-9][0-9]+)", validate_workflow, "validation workflow must use a Node 24-ready cache save action")
    require_regex(r"actions/upload-artifact@v([6-9]|[1-9][0-9]+)", validate_workflow, "validation workflow must use a Node 24-ready artifact upload action")
    require("id: build_artifacts" in validate_workflow, "validation workflow must identify the compile-heavy build step for cache-save gating")
    require("id: cache_payload" in validate_workflow, "validation workflow must inspect compiler cache payload before saving")
    require("steps.restore_ccache.conclusion == 'success'" in validate_workflow, "validation workflow must only save compiler cache after a successful restore step")
    require("steps.build_artifacts.conclusion == 'success'" in validate_workflow, "validation workflow must only save compiler cache after a successful compile-heavy build step")
    require("steps.cache_payload.outputs.save_ready == 'true'" in validate_workflow, "validation workflow must require a non-empty compiler cache payload before saving")
    require("steps.restore_ccache.outputs.cache-hit != 'true'" in validate_workflow, "validation workflow must skip cache save after an exact cache hit")
    require((REPO_ROOT / "config" / "platforms.json").exists(), "platform contract must exist")
    require((REPO_ROOT / "scripts" / "spm_release_support" / "platform_contract.py").exists(), "platform contract module missing")
    require((REPO_ROOT / "scripts" / "spm_release_support" / "release_planning.py").exists(), "release planning module missing")
    require((REPO_ROOT / "scripts" / "spm_release_support" / "package_validation.py").exists(), "package validation module missing")
    require('path: "Artifacts/' not in package_swift, "committed Package.swift must not use repo-local artifact paths")
    require("FileManager.default.fileExists" not in package_swift, "committed Package.swift must not switch on local checkout state")

    platform_contract = json.loads(read_text(REPO_ROOT / "config" / "platforms.json"))
    require("deployment_targets" in platform_contract, "platform contract must define deployment_targets")
    require("build_matrix" in platform_contract, "platform contract must define build_matrix")

    print("libwebp SOP conformance verified")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

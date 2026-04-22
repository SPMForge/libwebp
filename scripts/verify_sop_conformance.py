#!/usr/bin/env python3
from __future__ import annotations

import json
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
WORKFLOWS_DIR = REPO_ROOT / ".github" / "workflows"


def require(condition: bool, message: str) -> None:
    if not condition:
        raise SystemExit(message)


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
    require("workflow_call:" in publish_core, "publish core must be reusable via workflow_call")
    require("--latest=false" in publish_core, "alpha publishes must force latest=false")
    require("push:" in validate_workflow and "pull_request:" in validate_workflow, "validation workflow must run on push and pull_request")
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

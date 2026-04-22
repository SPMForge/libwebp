from __future__ import annotations

from dataclasses import dataclass
import re
from typing import Iterable

from spm_release_support.platform_contract import ARTIFACT_DEFINITIONS, RELEASE_METADATA_ASSETS


STABLE_TAG_PATTERN = re.compile(r"^v(\d+)\.(\d+)\.(\d+)$")
PACKAGE_STABLE_TAG_PATTERN = re.compile(r"^(\d+)\.(\d+)\.(\d+)$")
PACKAGE_RELEASE_TAG_PATTERN = re.compile(r"^(\d+)\.(\d+)\.(\d+)-alpha\.(\d+)$")


@dataclass(frozen=True)
class ReleaseArtifact:
    target_name: str
    library_name: str
    archive_name: str
    xcframework_name: str


@dataclass(frozen=True)
class ReleasePublicationPlan:
    mode: str
    required_assets: tuple[str, ...]
    missing_assets: tuple[str, ...]


def require_stable_tag(tag: str) -> tuple[int, int, int]:
    match = STABLE_TAG_PATTERN.fullmatch(tag)
    if match is None:
        raise ValueError(f"Expected a stable release tag like v1.6.0, got: {tag}")
    return tuple(int(component) for component in match.groups())


def require_package_release_tag(tag: str) -> tuple[int, int, int, int]:
    match = PACKAGE_RELEASE_TAG_PATTERN.fullmatch(tag)
    if match is None:
        raise ValueError(f"Expected a package release tag like 1.6.0-alpha.1, got: {tag}")
    return tuple(int(component) for component in match.groups())


def require_package_distribution_tag(tag: str) -> str:
    if PACKAGE_STABLE_TAG_PATTERN.fullmatch(tag) is not None:
        return tag
    require_package_release_tag(tag)
    return tag


def package_release_tag_for_upstream_tag(
    upstream_tag: str,
    *,
    channel: str = "alpha",
    sequence: int | None = None,
) -> str:
    major, minor, patch = require_stable_tag(upstream_tag)
    stable_tag = f"{major}.{minor}.{patch}"

    if channel == "stable":
        if sequence is not None:
            raise ValueError("Stable package releases do not use a prerelease sequence.")
        return stable_tag
    if channel != "alpha":
        raise ValueError(f"Unsupported release channel: {channel}")

    if sequence is None:
        sequence = 1
    if sequence <= 0:
        raise ValueError("Alpha sequence must be a positive integer.")
    return f"{stable_tag}-alpha.{sequence}"


def package_release_tags_for_upstream_tag(
    upstream_tag: str,
    tags: Iterable[str],
    *,
    channel: str = "alpha",
) -> list[str]:
    if channel == "stable":
        stable_tag = package_release_tag_for_upstream_tag(upstream_tag, channel="stable")
        return [tag for tag in tags if tag == stable_tag]

    stable_tag = package_release_tag_for_upstream_tag(upstream_tag, channel="stable")
    prefix = f"{stable_tag}-alpha."
    matching_tags: list[tuple[tuple[int, int, int, int], str]] = []
    for tag in tags:
        if not tag.startswith(prefix):
            continue
        parsed_tag = require_package_release_tag(tag)
        if parsed_tag[:3] == require_stable_tag(upstream_tag):
            matching_tags.append((parsed_tag, tag))
    matching_tags.sort(key=lambda item: item[0], reverse=True)
    return [tag for _, tag in matching_tags]


def latest_package_release_tag_for_upstream_tag(
    upstream_tag: str,
    tags: Iterable[str],
    *,
    channel: str = "alpha",
) -> str | None:
    matching_tags = package_release_tags_for_upstream_tag(upstream_tag, tags, channel=channel)
    if not matching_tags:
        return None
    return matching_tags[0]


def next_package_release_tag_for_upstream_tag(
    upstream_tag: str,
    tags: Iterable[str],
) -> str:
    latest_tag = latest_package_release_tag_for_upstream_tag(upstream_tag, tags)
    if latest_tag is None:
        return package_release_tag_for_upstream_tag(upstream_tag)

    _, _, _, latest_sequence = require_package_release_tag(latest_tag)
    return package_release_tag_for_upstream_tag(upstream_tag, sequence=latest_sequence + 1)


def select_latest_stable_tag(tags: Iterable[str]) -> str:
    stable_tags: list[tuple[tuple[int, int, int], str]] = []
    for tag in tags:
        if not tag:
            continue
        match = STABLE_TAG_PATTERN.fullmatch(tag)
        if match is None:
            continue
        stable_tags.append((tuple(int(component) for component in match.groups()), tag))

    if not stable_tags:
        raise ValueError("No stable release tag found in the provided input.")

    stable_tags.sort(key=lambda item: item[0], reverse=True)
    return stable_tags[0][1]


def release_artifacts_for_tag(tag: str) -> list[ReleaseArtifact]:
    require_package_distribution_tag(tag)
    return [
        ReleaseArtifact(
            target_name=definition.target_name,
            library_name=definition.library_name,
            archive_name=definition.archive_name_for_tag(tag),
            xcframework_name=definition.xcframework_name,
        )
        for definition in ARTIFACT_DEFINITIONS
    ]


def required_release_asset_names(tag: str) -> tuple[str, ...]:
    artifacts = release_artifacts_for_tag(tag)
    return tuple([*(artifact.archive_name for artifact in artifacts), *RELEASE_METADATA_ASSETS])


def plan_release_publication(
    *,
    tag: str,
    remote_tag_exists: bool,
    release_asset_names: Iterable[str],
) -> ReleasePublicationPlan:
    required_assets = required_release_asset_names(tag)
    published_assets = {asset_name for asset_name in release_asset_names if asset_name}
    missing_assets = tuple(asset_name for asset_name in required_assets if asset_name not in published_assets)
    if not remote_tag_exists:
        return ReleasePublicationPlan(mode="fresh", required_assets=required_assets, missing_assets=required_assets)
    if missing_assets:
        return ReleasePublicationPlan(mode="repair", required_assets=required_assets, missing_assets=missing_assets)
    return ReleasePublicationPlan(mode="skip", required_assets=required_assets, missing_assets=())

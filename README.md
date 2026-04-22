# libwebp

This repository publishes a Swift Package Manager binary distribution for
[`libwebp`](https://github.com/webmproject/libwebp). It builds mergeable Apple
XCFramework assets from upstream release tags and publishes them as GitHub
Releases so Swift clients can depend on versioned binaries instead of
rebuilding `libwebp` from source.

This repository is a packaging wrapper, not an upstream source mirror. It keeps
only packaging automation, generated package metadata, tests, and license
notices while CI dynamically fetches upstream source snapshots for builds.

## What Gets Published

Each release publishes five binary targets:

- `WebP`
- `WebPDecoder`
- `WebPDemux`
- `WebPMux`
- `SharpYuv`

The build matrix covers mergeable slices for:

- iOS
- iOS Simulator
- macOS
- Mac Catalyst
- tvOS
- tvOS Simulator
- watchOS
- watchOS Simulator
- visionOS
- visionOS Simulator

## Release Model

- Upstream source of truth: `https://github.com/webmproject/libwebp`
- Automatic publishing: the `publish-latest-upstream-alpha` workflow checks upstream
  stable tags (`vX.Y.Z`) on a schedule, selects the newest upstream stable
  source snapshot, and publishes or repairs the matching package prerelease.
  Alpha publishes remain prerelease-only and do not update the default branch
  `Package.swift`.
- Manual backfill: the `publish-upstream-release-manually` workflow publishes a specific stable
  upstream tag without requiring the repository to catch up through every
  historical version, and the operator must explicitly choose whether the
  package release should stay on the `alpha` channel or publish the stable
  package tag.
- Package tags: this repository owns the SwiftPM semver tags that clients
  consume. Stable public releases use `X.Y.Z`. Alpha package tags such as
  `X.Y.Z-alpha.N` remain available for prerelease validation and can increment
  on the same upstream stable release whenever the packaging pipeline needs
  another prerelease cut.
- The user-facing publish workflows delegate to a shared
  `publish-package-release-core` reusable workflow so scheduled and manual
  release paths stay on the same build, manifest, and publication logic.
- Source acquisition is defined by [`config/source-acquisition.json`](config/source-acquisition.json).
  CI builds from exported upstream tag snapshots instead of assuming the checked-out
  repository state is the release source of truth.
- CI compiler caching follows a narrow policy: persist only `.ccache` with
  `actions/cache`, scope it by cache schema, runner OS, Xcode version, upstream
  source commit, and repo-local build script inputs, and avoid caching
  `DerivedData` or other opaque Xcode build directories by default.
- Stable package tags such as `X.Y.Z` are reserved for the manual workflow.
  If a stable tag already exists with different generated package metadata, the
  workflow fails instead of overwriting published public artifacts.
- During this rollout, a rerun may keep repairing the latest matching
  `X.Y.Z-alpha.N` release or mint the next `alpha.N` if the generated package
  payload changed.
- If the latest alpha tag for an upstream release already matches the generated
  `Package.swift` but the GitHub Release is incomplete, the workflow repairs the
  missing assets instead of silently minting another prerelease number.
- Alpha GitHub Releases are explicitly published as prereleases and are
  normalized to `latest=false` so automated prerelease tags do not become the
  repository's public latest release by accident.
- Upstream tags are fetched into a dedicated `refs/upstream-tags/*` namespace in
  CI to avoid tag-name collisions with published package versions.
- The published binaries are mergeable dynamic libraries packaged as
  XCFrameworks. There is no static-library fallback release track.

## SwiftPM Usage

For public consumption, depend on a stable package release:

```swift
dependencies: [
    .package(url: "https://github.com/<owner>/<repository>.git", from: "1.6.0")
]
```

Replace `<owner>/<repository>` with the GitHub repository that publishes your
release assets. If you publish the package as `libwebp`, use that package
identity in downstream dependencies.

If you need to validate a prerelease packaging cut before a stable publish, pin
an explicit prerelease version instead:

```swift
dependencies: [
    .package(url: "https://github.com/<owner>/<repository>.git", exact: "1.6.0-alpha.12")
]
```

Then depend on one or more binary products:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "WebP", package: "libwebp"),
            .product(name: "WebPDemux", package: "libwebp"),
        ]
    )
]
```

The published products include the linked binary closure needed by each dynamic
library. `WebP` bundles `SharpYuv`, and both `WebPDemux` and `WebPMux` bundle
`WebP` plus `SharpYuv`, so consumers should depend on the highest-level product
they need instead of manually repeating those lower-level package products.

`Package.swift` is generated by release automation for each published package
tag and points to the matching release assets plus their checksums.

To let Xcode treat these binaries as mergeable inputs, enable merged binaries on
the consuming app or framework target for Release builds:

```xcconfig
MERGED_BINARY_TYPE = automatic
```

Debug builds can keep the default dynamic-link behavior.

## Local Release Tooling

The repository ships two release helpers:

- [`scripts/spm_release.py`](scripts/spm_release.py): selects stable upstream
  tags, derives package prerelease tags, renders `Package.swift`, computes
  checksums, prints the Apple build matrix, builds mergeable XCFrameworks,
  validates mergeable metadata, and runs local macOS consumer smoke tests for
  both the direct XCFramework path and a real SwiftPM binary-target integration
  in Debug and Release. It also owns the repo-local source acquisition contract
  used by CI to fetch and export upstream source snapshots.
- [`scripts/build_apple_xcframeworks.sh`](scripts/build_apple_xcframeworks.sh):
  thin wrapper around the Python release tool for local use and CI.
- [`.github/workflows/validate-apple-release-pipeline.yml`](.github/workflows/validate-apple-release-pipeline.yml):
  validates not only the XCFramework build output but also the rendered
  `Package.swift` contract for those freshly built artifacts. Manual dispatch
  can optionally pin a specific upstream stable tag for reproducible validation.

Example local build:

```shell
python3 scripts/spm_release.py fetch-upstream-tags --remote upstream
python3 scripts/spm_release.py export-upstream-source \
  --tag v1.6.0 \
  --output-dir /tmp/libwebp-source

./scripts/build_apple_xcframeworks.sh \
  --source-dir /tmp/libwebp-source \
  --output-dir /tmp/libwebp-artifacts \
  --tag 1.6.0-alpha.1 \
  --keep-xcframeworks
```

Build prerequisites:

- Xcode with iOS, macOS, tvOS, watchOS, and visionOS SDKs installed
- Python 3.10+
- `cmake`
- `xcrun vtool`
- Swift toolchain with `swift package compute-checksum`
- Requested Apple platform destinations must be available in Xcode; the build
  now fails fast instead of silently emitting a mislabeled fallback slice.

## Repository Notes

- This repository is not a pure mirror of upstream `libwebp`.
- The repository intentionally excludes the upstream `libwebp` source tree.
  Local debugging should use an exported upstream snapshot or a separate clone
  of the upstream project.
- Stable package tags are the public SwiftPM release surface. Alpha tags remain
  available only for prerelease validation and repair publishes.
- `watchOS` mergeable slices are published for `arm64` and `arm64_32`; `armv7k`
  is intentionally excluded because the current Apple linker does not support
  mergeable output for that architecture.
- If a release job fails after pushing a tag but before uploading all assets,
  rerun the manual backfill workflow for the same tag. The workflow now repairs
  the existing GitHub Release instead of rejecting the already-published tag.

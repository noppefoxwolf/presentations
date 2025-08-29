# Repository Guidelines

## Project Structure & Module Organization
- `Sources/AnimatedImage/`: Public API that re-exports platform layers; includes `Resources/PrivacyInfo.xcprivacy`.
- `Sources/AnimatedImageCore/`: Core types, decoders, processors, utilities.
- `Sources/_UIKit_AnimatedImage/`, `Sources/_AppKit_AnimatedImage/`: Platform implementations.
- `Sources/_SwiftUI_AnimatedImage/`: SwiftUI wrapper components.
- `Sources/UpdateLink/`: Display link and timing utilities.
- `Tests/AnimatedImageTests/`: Unit tests for utilities and processors.
- `Playground.swiftpm/`: Xcode Playground with UIKit/SwiftUI demos.

## Build, Test, and Development Commands
- Build: `swift build` (use `-c release` for optimized builds).
- Test: `swift test` or filter suites: `swift test --filter ImageProcessorTests`.
- Xcode project (optional): `swift package generate-xcodeproj`.
- Playground demo: open `Playground.swiftpm` in Xcode and run.
- Format: `swift format --configuration .swift-format --in-place Sources Tests`.

## Coding Style & Naming Conventions
- Indentation 4 spaces; line length 100; ordered imports (see `.swift-format`).
- Types/protocols UpperCamelCase (e.g., `AnimatedImageProvider`); methods/vars lowerCamelCase.
- Internal platform targets prefixed with `_` (e.g., `_UIKit_AnimatedImage`).
- Tests end with `Tests.swift` and are grouped by feature (e.g., `Processors/CGImageProcessorTests.swift`).

## Testing Guidelines
- Framework: Swift Testing (`import Testing`, `@Suite`, `@Test`).
- Scope: Focus on core processing (timing, decimation, image ops). Use mocks for images where needed.
- Run locally with `swift test`; use `--filter` for focused runs.
- CI: macOS 15, Xcode 16.4 — ensure tests pass there.

## Commit & Pull Request Guidelines
- Commits: imperative, concise, scoped (e.g., "Refactor size optimization", "Fix overflow in decimator").
- PRs: include description, linked issues, rationale, and updated tests. Attach screenshots or short videos for visual/API changes (from Playground).
- Verify before opening: `swift build` and `swift test`. Avoid adding MainActor work to heavy pipelines.

## Security & Configuration Tips
- Respect `PrivacyInfo.xcprivacy`; do not bundle sensitive assets.
- Minimum toolchain: Swift 6.1+; iOS 16+/macOS 14+/visionOS 1+ (see `Package.swift`).
- Use platform conditions for UIKit/AppKit; keep heavy processing off the main thread.

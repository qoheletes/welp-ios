# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

This project uses [Tuist](https://tuist.io) to generate Xcode projects from Swift manifests.

```bash
# Regenerate Xcode projects after changing any Project.swift or Workspace.swift
tuist generate

# Open the workspace
open Welp.xcworkspace
```

Build and run via Xcode (scheme: **Welp**) or:

```bash
xcodebuild -workspace Welp.xcworkspace -scheme Welp -destination 'platform=iOS Simulator,name=iPhone 17' build
```
## Code Formatting

**SwiftFormat** is configured in `.swiftformat`. Run before committing:

```bash
swiftformat .
```

Key formatting rules:
- 2-space indentation
- Max line width: 130 characters (strictly enforced)
- Swift 6.2 / language mode 5
- `override` comes *after* access control in modifier order

## Architecture

The project combines **Clean Architecture** with **Micro Feature Architecture** using Tuist. For more information on the structure, see `ARCHITECTURE.md`.

### 5-Layer Structure

```
App      → Application entry point
Feature  → Presentation (MVVM + Coordinator)
Domain   → Business logic (UseCases, Repository protocols, Entities)
Data     → Repository implementations, API clients, DTOs
Shared   → FeatureFoundation, DesignSystem, Utils, ThirdPartyLibrary
```

Dependencies flow strictly downward (App → Feature → Domain ← Data; all → Shared).

### Micro Feature Module Structure

Each feature module (`Projects/Feature/<Name>Feature/`) contains five targets:

| Target | Purpose |
|--------|---------|
| `Interface` | Public protocols & contracts consumed by other features |
| `Sources` | Implementation (Assembly, Coordinator, Factory, Presentation) |
| `Testing` | Mock/stub implementations shared across test targets |
| `Tests` | XCTest unit tests |
| `Demo` | Standalone runnable app for isolated development |

### Presentation Layer Pattern (Sources)

Each feature's `Sources` target is organized into four parts:

- **Assembly** — Swinject DI container registration
- **Coordinator** — Navigation logic (owns routing, not ViewControllers)
- **Factory** — Object creation & wiring
- **Presentation** — ViewController/View + ViewModel

### ViewModel Input/Output Pattern

```swift
protocol HomeViewModelInput {
    func viewDidLoad()
    // ...
}

struct HomeViewModelOutput {
    let state: HomeViewModelState   // UI state
    let route: HomeViewModelRoute   // Navigation events
}
```

Output is split into `State` (drives UI updates) and `Route` (drives coordinator navigation).

### Reactive Stack

- **Combine** - primary reactive framework throughout
- **Swinject** — dependency injection
- **Alamofire** — HTTP networking (via `Core/Networking`)
- **Rive** — animations

## Feature Modules

Current features: `RootFeature`, `SplashFeature`, `AskFeature`, `AuthFeature`, `ProfileFeature`, `OnboardingFeature`.

Domain module: `AskDomain`.

## Design System

All design tokens live in `Shared/DesignSystem/Sources/`:

- **Colors** (`Colors.swift`): `Color.welp*` extensions (e.g. `welpBg`, `welpTextAccent`, `welpYes`, `welpNo`)
- **Fonts** (`Fonts.swift`): `Font.sbAggroBold(_:)`, `Font.sbAggroMedium(_:)`, `Font.sbAggroLight(_:)` — wrapping SBAggroOTF fonts bundled in `App/Resources/Fonts/`

Always use these tokens rather than raw hex values or system fonts.

The app is dark-mode only (`UIUserInterfaceStyle: Dark`, `.preferredColorScheme(.dark)` enforced at the view level).

## Git Branch Naming

```
<type>/<scope>-<short-description>
```

Types: `feat`, `fix`, `chore`, `refactor`, `docs`, `test`, `perf`, `ci`

Examples: `feat/auth-add-oauth-login`, `fix/home-crash-on-load`

Include a ticket ID when available: `feat/PROJ-123-auth-social-login`



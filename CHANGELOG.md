# Changelog

All notable changes to this project will be documented in this file.

Format based on [Keep a Changelog](https://keepachangelog.com/), versioned per [Semantic Versioning](https://semver.org/).

## [1.1.1] - 2026-02-22

### Fixed
- YAML frontmatter in SKILL.md quoted to fix GitHub rendering error

## [1.1.0] - 2026-02-21

### Added
- `/bcomp` shorthand alias for `/branch-compare`
- Configurable diff tool via environment variable, settings file, or default
- Marketplace plugin install support (`marketplace.json`)
- `plugin.json` manifest
- macOS, Linux, and Windows/WSL platform support documentation

### Changed
- Renamed from `bcomp-branches` to `branch-compare`
- Restructured repo as marketplace with plugin subdirectory

### Fixed
- Homepage URL updated to renamed repo
- Author name corrected in `plugin.json`, `marketplace.json`, and LICENSE
- Installation commands in README

## [1.0.0] - 2026-02-20

### Added
- Initial release of branch comparison plugin for Claude Code
- Git worktree-based side-by-side branch comparison using Beyond Compare
- Automatic worktree creation and cleanup
- Interactive and non-interactive modes

[1.1.1]: https://github.com/MatthewMaker/branch-compare/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/MatthewMaker/branch-compare/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/MatthewMaker/branch-compare/releases/tag/v1.0.0

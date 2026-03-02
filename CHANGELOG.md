# Changelog

All notable changes to this project will be documented in this file.

Format based on [Keep a Changelog](https://keepachangelog.com/), versioned per [Semantic Versioning](https://semver.org/).

## [1.2.1] - 2026-03-01

### Removed
- `/bcomp` shorthand alias — with only one skill, the command appears as just `/branch-compare` without redundant namespacing

## [1.2.0] - 2026-02-26

### Added
- Filter presets for project types: `unity`, `web`, `python`, `godot`
- Auto-detection of project type based on directory markers (e.g., Unity detected by `ProjectSettings/` + `Assets/`)
- `--filter=<preset|raw|none>` CLI flag for explicit filter control
- `filters` setting in `.claude/branch-compare.local.md` frontmatter
- Raw filter string passthrough for custom masks

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

[1.2.1]: https://github.com/MatthewMaker/branch-compare/compare/v1.2.0...v1.2.1
[1.2.0]: https://github.com/MatthewMaker/branch-compare/compare/v1.1.1...v1.2.0
[1.1.1]: https://github.com/MatthewMaker/branch-compare/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/MatthewMaker/branch-compare/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/MatthewMaker/branch-compare/releases/tag/v1.0.0

---
name: branch-compare
description: >-
  Compare two git branches side-by-side using a configurable diff tool (defaults
  to Beyond Compare) and temporary worktrees. Use when the user wants to visually
  diff branches, compare branch contents, or open a folder comparison between two
  git refs. Defaults to comparing the current branch against develop.
argument-hint: "[--filter=<preset>] [branch1] [branch2]"
allowed-tools:
  - "Bash(bash ${CLAUDE_PLUGIN_ROOT}/scripts/branch-compare.sh:*)"
  - "Bash(git branch:*)"
  - "Bash(git worktree:*)"
  - "Bash(git rev-parse:*)"
  - "Bash(git fetch:*)"
---

Compare two git branches using a configurable diff tool and worktrees.

Usage: /branch-compare [--filter=<preset|raw|none>] [branch1] [branch2]

Arguments are optional and passed via `$ARGUMENTS`:
- No arguments: compare the current branch against `develop`
- One argument: compare the current branch against that branch
- Two arguments: compare branch1 (left) against branch2 (right)

## Filter Options

The `--filter` flag controls which files/folders are shown in the comparison:

- **Preset name**: `--filter=unity`, `--filter=web`, `--filter=python`, `--filter=godot`
- **Raw filter string**: `--filter="*.cs;*.shader"` (passed directly to the diff tool)
- **Disable auto-detection**: `--filter=none`
- **Omitted**: auto-detects the project type based on directory markers

### Available Presets

| Preset | Detects | Excludes |
|--------|---------|----------|
| `unity` | `ProjectSettings/` + `Assets/` | Library, Temp, Logs, Build, obj, .vs, UserSettings, etc. |
| `web` | `package.json` | node_modules, dist, build, .next, .nuxt, coverage, etc. |
| `python` | `pyproject.toml` or `setup.py` | \_\_pycache\_\_, .venv, .mypy_cache, .pytest_cache, etc. |
| `godot` | `project.godot` | .godot, .import, addons |

Auto-detection runs on the git repo root and prints a message when a project type is recognized.

## Configuration

The comparison tool and filters are resolved in priority order:

### Tool
1. **Environment variable**: `BRANCH_COMPARE_TOOL=meld`
2. **Settings file**: `.claude/branch-compare.local.md` with `compare_tool: meld` in frontmatter
3. **Default**: `bcomp` (Beyond Compare)

### Filters
1. **CLI flag**: `--filter=<value>`
2. **Settings file**: `.claude/branch-compare.local.md` with `filters: unity` in frontmatter
3. **Auto-detection**: based on project directory markers
4. **None**: no filters applied

## Execution

Run the script with `--no-prompt` to suppress interactive prompts:

bash ${CLAUDE_PLUGIN_ROOT}/scripts/branch-compare.sh --no-prompt $ARGUMENTS

The script will:
1. Resolve the comparison tool from env var, settings file, or default (`bcomp`)
2. Resolve filters from CLI flag, settings file, auto-detection, or none
3. Validate that the tool is installed and the current directory is a git repo
4. Resolve each branch (checking local refs, remote-tracking refs, and fetching from origin)
5. Reuse existing worktrees when available; create temporary detached worktrees otherwise
6. Open the diff tool with the two worktree root directories (with filters if applicable)
7. Clean up any temporary worktrees after the tool exits

## After running

Report to the user which two branches are being compared, which tool was
used, and which filters are active (if any). If the script exits with an error,
relay the error message verbatim.

## Error cases

- "not found on PATH" — the configured comparison tool is not installed. If
  using the default (`bcomp`), suggest installing Beyond Compare from
  https://www.scootersoftware.com/
- "not inside a git repository" — the working directory is not a git repo.
- "branch not found" — the specified branch does not exist locally or on the
  remote.

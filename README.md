# branch-compare

A Claude Code plugin that compares git branches side-by-side using a configurable diff tool (defaults to [Beyond Compare](https://www.scootersoftware.com/)) and git worktrees.

## What it does

Creates temporary git worktrees for the requested branches and opens them in your preferred diff tool for a full directory comparison. Existing worktrees are reused when available. Temporary worktrees are cleaned up automatically.

## Supported platforms

- **macOS** and **Linux** — works anywhere your diff tool and git are available
- **Windows** — requires WSL or Git Bash

## Prerequisites

- A directory diff tool (default: [Beyond Compare](https://www.scootersoftware.com/) with `bcomp` on PATH)
- Git

### Installing Beyond Compare CLI tools (if using default)

- **macOS**: Beyond Compare → Menu → Install Command Line Tools
- **Linux**: The `bcomp` command is included in the Beyond Compare package (`deb`/`rpm`)

## Installation

From within Claude Code, run:

```
/plugin marketplace add MatthewMaker/branch-compare
/plugin install branch-compare@MatthewMaker
```

## Usage

Inside Claude Code, use the slash command (`/bcomp` also works as a shorthand):

```
/branch-compare                    # current branch vs develop
/branch-compare main               # current branch vs main
/branch-compare feature develop    # feature vs develop
```

### Direct CLI usage

The script also works standalone:

```bash
# Interactive mode (prompts before deleting temp worktrees)
bash scripts/branch-compare.sh main feature

# Non-interactive mode (auto-deletes temp worktrees)
bash scripts/branch-compare.sh --no-prompt main feature
```

## Configuration

The comparison tool is resolved in priority order:

### 1. Environment variable

```bash
export BRANCH_COMPARE_TOOL=meld
```

### 2. Settings file

Create `.claude/branch-compare.local.md` in your project root:

```markdown
---
compare_tool: meld
---
```

### 3. Default

If neither is set, the script defaults to `bcomp` (Beyond Compare).

### Multi-word commands

Tools that require flags (e.g., VS Code's diff mode) work as expected:

```bash
export BRANCH_COMPARE_TOOL="code --diff"
```

## How it works

1. Resolves the comparison tool from env var, settings file, or default
2. Resolves the requested branches (local, remote-tracking, or fetches from origin)
3. For each branch, checks if a git worktree already exists — if so, reuses it
4. If no worktree exists, creates a temporary detached worktree
5. Opens both worktree roots in the configured diff tool
6. Cleans up temporary worktrees after the tool exits

## License

MIT

# bcomp-branches

A Claude Code plugin that compares git branches side-by-side in [Beyond Compare](https://www.scootersoftware.com/) using git worktrees.

## What it does

Creates temporary git worktrees for the requested branches and opens them in Beyond Compare for a full directory comparison. Existing worktrees are reused when available. Temporary worktrees are cleaned up automatically.

## Prerequisites

- [Beyond Compare](https://www.scootersoftware.com/) with CLI tools installed (`bcomp` on PATH)
- Git

### Installing Beyond Compare CLI tools

Beyond Compare → Menu → Install Command Line Tools

## Installation

```bash
claude plugin install MatthewMaker/bcomp-branches
```

## Usage

Inside Claude Code, use the slash command:

```
/bcomp-branches                    # current branch vs develop
/bcomp-branches main               # current branch vs main
/bcomp-branches feature develop    # feature vs develop
```

### Direct CLI usage

The script also works standalone:

```bash
# Interactive mode (prompts before deleting temp worktrees)
bash scripts/bcomp-branches.sh main feature

# Non-interactive mode (auto-deletes temp worktrees)
bash scripts/bcomp-branches.sh --no-prompt main feature
```

## How it works

1. Resolves the requested branches (local, remote-tracking, or fetches from origin)
2. For each branch, checks if a git worktree already exists — if so, reuses it
3. If no worktree exists, creates a temporary detached worktree
4. Opens both worktree roots in Beyond Compare
5. Cleans up temporary worktrees after Beyond Compare exits

## License

MIT

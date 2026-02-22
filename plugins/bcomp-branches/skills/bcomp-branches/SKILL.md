---
name: bcomp-branches
description: >-
  Compare two git branches side-by-side in Beyond Compare using temporary
  worktrees. Use when the user wants to visually diff branches, compare branch
  contents in Beyond Compare, or open a folder comparison between two git refs.
  Defaults to comparing the current branch against develop.
argument-hint: [branch1] [branch2]
allowed-tools:
  - Bash(bash ${CLAUDE_PLUGIN_ROOT}/scripts/bcomp-branches.sh:*)
  - Bash(git branch:*)
  - Bash(git worktree:*)
  - Bash(git rev-parse:*)
  - Bash(git fetch:*)
---

Compare two git branches in Beyond Compare using worktrees.

Usage: /bcomp-branches [branch1] [branch2]

Arguments are optional and passed via `$ARGUMENTS`:
- No arguments: compare the current branch against `develop`
- One argument: compare the current branch against that branch
- Two arguments: compare branch1 (left) against branch2 (right)

## Execution

Run the script with `--no-prompt` to suppress interactive prompts:

bash ${CLAUDE_PLUGIN_ROOT}/scripts/bcomp-branches.sh --no-prompt $ARGUMENTS

The script will:
1. Validate that `bcomp` is installed and the current directory is a git repo
2. Resolve each branch (checking local refs, remote-tracking refs, and fetching from origin)
3. Reuse existing worktrees when available; create temporary detached worktrees otherwise
4. Open Beyond Compare with the two worktree root directories
5. Clean up any temporary worktrees after Beyond Compare exits

## After running

Report to the user which two branches are being compared and confirm Beyond
Compare was launched. If the script exits with an error, relay the error
message verbatim.

## Error cases

- "bcomp not found" — Beyond Compare CLI tools are not installed. Suggest
  the user install them from https://www.scootersoftware.com/
- "not inside a git repository" — the working directory is not a git repo.
- "branch not found" — the specified branch does not exist locally or on the
  remote.

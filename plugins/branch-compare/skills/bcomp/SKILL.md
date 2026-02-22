---
name: bcomp
description: >-
  Alias for /branch-compare. Compare two git branches side-by-side using a
  configurable diff tool (defaults to Beyond Compare) and temporary worktrees.
  Defaults to comparing the current branch against develop.
argument-hint: [branch1] [branch2]
allowed-tools:
  - Bash(bash ${CLAUDE_PLUGIN_ROOT}/scripts/branch-compare.sh:*)
  - Bash(git branch:*)
  - Bash(git worktree:*)
  - Bash(git rev-parse:*)
  - Bash(git fetch:*)
---

Alias for `/branch-compare`. See that skill for full documentation.

Usage: /bcomp [branch1] [branch2]

## Execution

bash ${CLAUDE_PLUGIN_ROOT}/scripts/branch-compare.sh --no-prompt $ARGUMENTS

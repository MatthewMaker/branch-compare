---
name: bcomp-branches
description: Compare git branches side-by-side in Beyond Compare
argument-hint: [branch1] [branch2]
allowed-tools:
  - Bash(bash ${CLAUDE_PLUGIN_ROOT}/scripts/bcomp-branches.sh:*)
  - Bash(git branch:*)
  - Bash(git worktree:*)
---

Compare two git branches in Beyond Compare using worktrees.

Usage: /bcomp-branches [branch1] [branch2]

Arguments are optional:
- branch1 defaults to the current branch
- branch2 defaults to "develop"

Run the script:
bash ${CLAUDE_PLUGIN_ROOT}/scripts/bcomp-branches.sh --no-prompt $ARGUMENTS

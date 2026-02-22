#!/usr/bin/env bash
set -euo pipefail

# branch-compare: Open a diff tool on the worktree roots of two git branches.
#
# Usage: branch-compare [--no-prompt] [branch1] [branch2]
#   branch1 defaults to the current branch
#   branch2 defaults to "develop"
#
# Options:
#   --no-prompt   Auto-delete temporary worktrees without prompting (for non-interactive use)
#
# The comparison tool is resolved in priority order:
#   1. BRANCH_COMPARE_TOOL environment variable
#   2. compare_tool setting in .claude/branch-compare.local.md frontmatter
#   3. Default: bcomp (Beyond Compare)
#
# For each branch, if a worktree already exists, its path is used.
# Otherwise a temporary worktree is created and cleaned up afterward.

# --- Parse flags ---

NO_PROMPT=false
args=()
for arg in "$@"; do
  case "$arg" in
    --no-prompt) NO_PROMPT=true ;;
    *) args+=("$arg") ;;
  esac
done
set -- "${args[@]+"${args[@]}"}"

# --- Resolve comparison tool ---
# Priority: env var > settings file > default (bcomp)

COMPARE_TOOL="${BRANCH_COMPARE_TOOL:-}"

if [[ -z "$COMPARE_TOOL" ]]; then
  STATE_FILE=".claude/branch-compare.local.md"
  if [[ -f "$STATE_FILE" ]]; then
    FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$STATE_FILE")
    COMPARE_TOOL=$(echo "$FRONTMATTER" | grep '^compare_tool:' | sed 's/compare_tool: *//' | sed 's/^"\(.*\)"$/\1/')
  fi
fi

COMPARE_TOOL="${COMPARE_TOOL:-bcomp}"

# --- Pre-flight checks ---

# Split COMPARE_TOOL into command and fixed args (e.g., "code --diff" → cmd=code)
read -ra COMPARE_CMD <<< "$COMPARE_TOOL"

if ! command -v "${COMPARE_CMD[0]}" &>/dev/null; then
  echo "Error: '${COMPARE_CMD[0]}' not found on PATH." >&2
  if [[ "${COMPARE_CMD[0]}" == "bcomp" ]]; then
    echo "Install Beyond Compare and its CLI tools: https://www.scootersoftware.com/" >&2
  else
    echo "Ensure '${COMPARE_CMD[0]}' is installed and on your PATH." >&2
  fi
  exit 1
fi

if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "Error: not inside a git repository." >&2
  exit 1
fi

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"

if [[ $# -eq 0 ]]; then
  BRANCH1="$CURRENT_BRANCH"
  BRANCH2="develop"
elif [[ $# -eq 1 ]]; then
  BRANCH1="$CURRENT_BRANCH"
  BRANCH2="$1"
else
  BRANCH1="$1"
  BRANCH2="$2"
fi

# Resolve a branch argument to a valid git ref.
# Checks: local branch, remote-tracking ref, then tries fetching from origin.
resolve_branch() {
  local branch="$1"
  if git rev-parse --verify "refs/heads/$branch" &>/dev/null; then
    return 0
  fi
  if git rev-parse --verify "refs/remotes/$branch" &>/dev/null; then
    return 0
  fi
  # If it looks like origin/..., try fetching the remote branch
  if [[ "$branch" == origin/* ]]; then
    local remote_branch="${branch#origin/}"
    echo "Fetching '$remote_branch' from origin ..." >&2
    if git fetch origin "$remote_branch:refs/remotes/origin/$remote_branch" 2>/dev/null; then
      return 0
    fi
  fi
  echo "Error: branch '$branch' not found (checked local, remote-tracking, and fetch)." >&2
  return 1
}

# Validate both branches exist before creating any worktrees
for branch in "$BRANCH1" "$BRANCH2"; do
  resolve_branch "$branch" || exit 1
done

TEMP_WORKTREES=()

cleanup_temps() {
  if [[ ${#TEMP_WORKTREES[@]} -eq 0 ]]; then
    return
  fi
  echo ""
  echo "Temporary worktrees were created:"
  for wt in "${TEMP_WORKTREES[@]}"; do
    echo "  $wt"
  done
  if [[ "$NO_PROMPT" == true ]]; then
    for wt in "${TEMP_WORKTREES[@]}"; do
      echo "Removing $wt ..."
      git worktree remove --force "$wt"
    done
    echo "Done."
  else
    read -rp "Delete them? [Y/n] " answer
    if [[ "${answer,,}" != "n" ]]; then
      for wt in "${TEMP_WORKTREES[@]}"; do
        echo "Removing $wt ..."
        git worktree remove --force "$wt"
      done
      echo "Done."
    else
      echo "Kept. Remove manually with: git worktree remove <path>"
    fi
  fi
}

path_for_branch() {
  local branch="$1"
  local path

  # Check existing worktrees for this branch (local and remote-tracking refs)
  path=$(git worktree list --porcelain | awk -v branch="$branch" '
    /^worktree / { wt = substr($0, 10) }
    /^branch /   { if (substr($0, 8) == "refs/heads/" branch) print wt }
    /^branch /   { if (substr($0, 8) == "refs/remotes/" branch) print wt }
  ')

  if [[ -n "$path" ]]; then
    echo "$path"
    return
  fi

  # Resolve the ref to a commit for --detach worktree
  local ref
  if git rev-parse --verify "refs/heads/$branch" &>/dev/null; then
    ref="refs/heads/$branch"
  elif git rev-parse --verify "refs/remotes/$branch" &>/dev/null; then
    ref="refs/remotes/$branch"
  else
    echo "Error: could not resolve '$branch' to a ref." >&2
    return 1
  fi

  # Create a temporary worktree
  local sanitized
  sanitized=$(echo "$branch" | tr '/' '-')
  local tmpdir
  tmpdir="$(git rev-parse --show-toplevel)/../.branch-compare-tmp-${sanitized}-$$"
  echo "Creating temporary worktree for '$branch' at $tmpdir ..." >&2
  git worktree add "$tmpdir" "$ref" --detach >/dev/null 2>&1
  TEMP_WORKTREES+=("$tmpdir")
  echo "$tmpdir"
}

PATH1=$(path_for_branch "$BRANCH1")
PATH2=$(path_for_branch "$BRANCH2")

echo "Comparing:"
echo "  Left:  $PATH1  ($BRANCH1)"
echo "  Right: $PATH2  ($BRANCH2)"
echo "  Tool:  $COMPARE_TOOL"
echo ""

"${COMPARE_CMD[@]}" "$PATH1" "$PATH2"

cleanup_temps

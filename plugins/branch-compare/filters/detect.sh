#!/usr/bin/env bash
# Auto-detect project type from directory markers.
# Returns a preset name (matching a key in FILTER_PRESETS) or empty string.

detect_project_type() {
  local dir="$1"
  if [[ -d "$dir/ProjectSettings" && -d "$dir/Assets" ]]; then echo "unity"; return; fi
  if [[ -f "$dir/package.json" ]]; then echo "web"; return; fi
  if [[ -f "$dir/pyproject.toml" || -f "$dir/setup.py" || -f "$dir/setup.cfg" ]]; then echo "python"; return; fi
  if [[ -f "$dir/project.godot" ]]; then echo "godot"; return; fi
  echo ""
}

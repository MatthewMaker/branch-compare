#!/usr/bin/env bash
# Filter presets for branch-compare.
# Each preset is a Beyond Compare -filters= mask string.
# Syntax: -FolderName/ excludes a folder; *.ext includes only matching files; semicolons separate masks.

declare -A FILTER_PRESETS=(
  [unity]="-.git/;-*.csproj;-*.sln;-*.userprefs;-*.pidb;-*.unityproj;-.vs/;-*_DoNotShip/;-ExportedObj/;-.vscode/;-.idea/;-.utmp/;-.bezisidekick/;-Library/;-Temp/;-Logs/;-obj/;-Build/;-Builds/;-UserSettings/;-.gradle/"
  [web]="-node_modules/;-dist/;-build/;-.next/;-.nuxt/;-coverage/;-.cache/;-.parcel-cache/"
  [python]="-__pycache__/;-.venv/;-venv/;-.mypy_cache/;-.pytest_cache/;-*.egg-info/;-.tox/;-htmlcov/"
  [godot]="-addons/;-.godot/;-.import/"
)

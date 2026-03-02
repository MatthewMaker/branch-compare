#!/usr/bin/env bash
# Filter presets for branch-compare.
# Each preset is a Beyond Compare -filters= mask string.
# Syntax: -FolderName/ excludes a folder; *.ext includes only matching files; semicolons separate masks.
#
# Uses a function instead of associative arrays for bash 3.2 (macOS) compatibility.

get_filter_preset() {
  case "$1" in
    unity)  echo "-.git/;-*.csproj;-*.sln;-*.userprefs;-*.pidb;-*.unityproj;-.vs/;-*_DoNotShip/;-ExportedObj/;-.vscode/;-.idea/;-.utmp/;-.bezisidekick/;-Library/;-Temp/;-Logs/;-obj/;-Build/;-Builds/;-UserSettings/;-.gradle/" ;;
    web)    echo "-node_modules/;-dist/;-build/;-.next/;-.nuxt/;-coverage/;-.cache/;-.parcel-cache/" ;;
    python) echo "-__pycache__/;-.venv/;-venv/;-.mypy_cache/;-.pytest_cache/;-*.egg-info/;-.tox/;-htmlcov/" ;;
    godot)  echo "-addons/;-.godot/;-.import/" ;;
    *)      return 1 ;;
  esac
}

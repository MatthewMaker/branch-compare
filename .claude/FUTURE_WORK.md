# Future Work

## Bugs to Report

- **Claude Code: Skills with spaces in `name` fail as slash commands** — When a skill's frontmatter has a space in the `name` field (e.g., `name: Plugin Settings`), Claude Code offers it as a slash command completion but then only parses the first word, resulting in "Unknown skill: Plugin". The fully qualified form (`/plugin-dev:plugin-settings`) works fine. Report at https://github.com/anthropics/claude-code/issues

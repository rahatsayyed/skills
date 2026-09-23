#!/usr/bin/env sh
# SessionStart hook: injects the full i-have-adhd ruleset by default, every
# session. Opt out by setting I_HAVE_ADHD_ALWAYS_ON=off, e.g. in the "env"
# block of Claude Code's settings.json:
#   "env": { "I_HAVE_ADHD_ALWAYS_ON": "off" }
# Never blocks session start: any failure exits 0.
#
# POSIX so it runs with sh on macOS/Linux and Git Bash on Windows without a
# Node install.

[ "$I_HAVE_ADHD_ALWAYS_ON" = "off" ] && exit 0

# $0 is the absolute script path substituted into hooks.json by Claude Code,
# so resolve SKILL.md relative to it instead of trusting an exported env var.
script_dir=$(dirname -- "$0")
skill_path="$script_dir/../skills/productivity/i-have-adhd/SKILL.md"
[ -f "$skill_path" ] || exit 0

# Strip a leading YAML frontmatter block (--- ... --- at the very top of file).
# An unterminated fence is not frontmatter, so the whole file is kept unless the
# closing delimiter exists.
body=$(awk '
  NR == FNR {
    if (NR == 1 && $0 ~ /^---[[:space:]]*$/) { in_fm = 1; next }
    if (in_fm && $0 ~ /^---[[:space:]]*$/)   { in_fm = 0; closed = 1 }
    next
  }
  FNR == 1 { strip = closed }
  strip && FNR == 1 && $0 ~ /^---[[:space:]]*$/ { skipping = 1; next }
  skipping && $0 ~ /^---[[:space:]]*$/          { skipping = 0; next }
  !skipping { print }
' "$skill_path" "$skill_path") || exit 0

printf 'ADHD MODE ACTIVE (default-on). The ruleset below applies to every response. "stop adhd mode" turns it off for this session; set I_HAVE_ADHD_ALWAYS_ON=off in settings.json "env" to turn this off for good.\n\n%s\n' \
  "$body"

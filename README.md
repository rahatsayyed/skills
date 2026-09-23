# Skills

My personal Claude Code skills. Small, single-purpose, and built for how I
actually work — not a framework, just the workflows I use every day.

## Install

```bash
npx skills@latest add rahatsayyed/skills
```

The installer lets you pick which skills to take, and which agents to
install them on.

## Reference

- **[standup](./skills/productivity/standup/SKILL.md)**: Generate an
  EOD/standup status update from your own GitLab or GitHub activity over a
  given time period — reads commits, their diffs, and any merge/pull
  requests you reviewed, groups the result by feature/MR/PR, and asks once
  for anything the platform can't see (meetings, calls, blockers) before
  writing the status.
- **[i-have-adhd](./skills/productivity/i-have-adhd/SKILL.md)**: Shape output
  for an ADHD reader — leads with the next action, numbers multi-step work,
  restates state each turn, caps lists, cuts tangents and pleasantries. On by
  default for every session via a `SessionStart` hook (`hooks/hooks.json` +
  `hooks/i-have-adhd-always-on.sh`); say "stop adhd mode" to turn it off for
  just the current session. Vendored from
  [ayghri/i-have-adhd](https://github.com/ayghri/i-have-adhd) — see
  `skills/productivity/i-have-adhd/.source.json` for the pinned commit and
  update steps.

  Turn it off for good with an env var in Claude Code's `settings.json`:

  ```json
  "env": { "I_HAVE_ADHD_ALWAYS_ON": "off" }
  ```

  Note: the skill also ships `disable-model-invocation: true` (upstream's
  original setting, meant for on-demand `/i-have-adhd` invocation). In this
  Claude Code build that path does not currently work — the hook above is
  the only way to turn this skill on.

More skills get added under `skills/<name>/` as they come up.

## Other

- **[scripts/statusline.sh](./scripts/statusline.sh)**: Powerline-style
  Claude Code status line (git status, context/cost info). Not a skill —
  Claude Code plugins cannot auto-register the main `statusLine` setting, so
  this needs one manual step. See the setup comment at the top of the file,
  or:

  ```json
  "statusLine": {
    "type": "command",
    "command": "~/.claude/plugins/marketplaces/personal-skills/scripts/statusline.sh"
  }
  ```

  in `~/.claude/settings.json`, then run `/reload-plugins` once. After that,
  edits to this file just need commit + push + `/reload-plugins` — no
  re-copying.

## Notes

- State a skill needs to remember across runs (like a GitLab username) is
  saved through Claude's own memory system, never written into a file
  inside the skill's own folder — an installed/synced skill directory can
  get reset on the next update, so anything worth keeping has to live
  outside it.

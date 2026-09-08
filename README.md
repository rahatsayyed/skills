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

- **[standup](./skills/standup/SKILL.md)**: Generate an EOD/standup status
  update from your own GitLab activity over a given time period — reads
  commits, their diffs, and any merge requests you reviewed, groups the
  result by feature/MR, and asks once for anything GitLab can't see
  (meetings, calls, blockers) before writing the status.
- **[i-have-adhd](./skills/i-have-adhd/SKILL.md)**: Shape output for an ADHD
  reader — leads with the next action, numbers multi-step work, restates
  state each turn, caps lists, cuts tangents and pleasantries. Off by
  default; turn on with `/i-have-adhd`, off with "stop adhd mode". Vendored
  from [ayghri/i-have-adhd](https://github.com/ayghri/i-have-adhd) — see
  `skills/i-have-adhd/.source.json` for the pinned commit and update steps.

More skills get added under `skills/<name>/` as they come up.

## Notes

- State a skill needs to remember across runs (like a GitLab username) is
  saved through Claude's own memory system, never written into a file
  inside the skill's own folder — an installed/synced skill directory can
  get reset on the next update, so anything worth keeping has to live
  outside it.

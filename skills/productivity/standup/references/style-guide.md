# EOD status style guide

Real tone samples, anonymized. Match this shape, not these words.

## Shape

- Header line: `EOD STATUS:`. 
- One section per MR or feature area. Bold or plain title line, then bullets.
- Bullets are short, factual, past tense: what changed and why, not just
  the commit subject line.
- **Always use markdown `-` bullets, never flat lines.** Nest a `-`
  sub-bullet list under a section when that section bundles several
  distinct fix-areas under one MR/category (see worked example 2).
- If the work involved investigation (a bug, a review pushback, a design
  question), write 2-4 sentences of prose describing what was found and what
  was decided — this is where the diff matters more than the commit log.
- Link merge/pull requests inline where relevant: `MR - <url>` or `(!1234)`
  on GitLab, `PR - <url>` or `(#1234)` on GitHub. Match whichever platform
  the activity came from — don't mix notations in one status.
- A non-code section (customer calls, meetings, blockers, environment
  issues) goes last, same terse style, no separate "summary" or "reflection"
  paragraph.
- No filler like "Today I worked on..." or "In summary...". Start directly
  with the feature name or the action.

## Worked example

```
EOD STATUS:

- Config toggle for feature X (!1234)
  - Relabeled and refactored the mode flag to a plain enable/disable boolean
  - Reworked the dropdown interaction, role-gated the action
  - Wired GET/POST endpoints for the new state
  - Default-expanded the settings section; minor layout fix
- Bug review on the latency-sensitive path
- Reviewed the flagged issue; traced it to stale test data from a scripted load-test run, not a real regression.
- Found the cache logic was also hitting the DB for freshness checks on a hot read path — fixed invalidation on both write paths, and made the hot read path cache-only. Latency improved on that path as a result. MR - https://gitlab.example.com/group/project/-/merge_requests/2750

Reviews:
- Reviewed a handful of smaller MRs (naming cleanup, a locale fix, a timestamp field).

Environment:
- Still blocked on local dev setup (OS mismatch with the required tooling) — using a remote box as a workaround for now.
```

## Worked example 2

Use this shape when several MRs each bundle multiple small, unrelated fixes:

```
EOD STATUS:
- Model routing bug fixes (!1201, !1202):
  - Removed an unreliable tooltip on the route card
  - Added a loading spinner to stop an empty-state flash
  - Fixed stale weight recalculation when a model is removed
  - Clamped the weight input to a minimum of 0
- Backend validation error surfacing (!1210):
  - Error helper now joins array-style validation errors into one message
  - Applied it across the affected forms
```

## What NOT to do

- Don't paste raw commit messages 1:1 as bullets — rephrase into what the
  change accomplished.
- Don't invent detail the diff doesn't support.
- Don't include real customer/company/teammate names in any file that gets
  committed to this repo's history if the repo might ever go public — keep
  those in the live status you show the user, not in stored examples.

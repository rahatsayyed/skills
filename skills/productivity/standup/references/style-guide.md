# EOD status style guide

Tone samples are anonymized. Match this shape and voice, not these words.

## Voice (most important)

- Use plain, simple words. Write short sentences. Give one fact in each
  sentence.
- Say the problem first, then the fix. Use "Before, it showed X" or "The page
  did X" for the old state. Then say what it does now.
- Say why it matters, not only what changed. Name the symptom that a user or
  developer saw (a flash, a clipped label, a duplicate request, a console
  error).
- Use past tense for finished work. Use present tense for current behavior
  ("The modal now shows...").
- Prefer active voice. Do not write "I worked on" or "was done". Start a
  bullet with the action or the feature ("Moved...", "Added...", "Fixed...").
- Use real names from the code: component, hook, endpoint, file, prop. Put
  them in backticks. This makes the status easy to check.
- No filler: no "Today I worked on...", no "In summary...", no closing
  reflection.
- No marketing words (robust, seamless, enhanced, improved performance). Give
  the fact: "one request instead of two", "219 s to 50 s".

## Format (always markdown)

- The output is always valid markdown. Never output flat lines or Slack-only
  symbols (`•`, `◦`).
- Top-level bullets use `-`. Nested bullets use `-` with exactly 2 spaces of
  indentation for each level. Do not use tabs. Do not mix `-` and `*`.
- Put one blank line after the header line.
- Put one blank line before a new group such as `Reviews:` or `Blocked:`.
- Wrap code names (files, hooks, props, endpoints, branch names) in
  backticks.
- Check the indentation before you send. A sub-bullet that is not indented
  by 2 spaces under its parent is a mistake.

## Shape

- Header line: `EOD STATUS:` (add the date only if the user does, for example
  `EOD STATUS: 14 Oct 2026`).
- One top-level bullet for each MR or feature area. Put the MR number and its
  state in the title: `(!3122, merged)`, `(!2891, open)`, `(!2949, in
  review)`, `(!2965, draft)`. Add the target branch when it is not the
  default: `(!3048, target rel-1.3.11)`.
- Under each top bullet, use sub-bullets. Each sub-bullet is one change, one
  cause, or one result. Keep 2 to 6 sub-bullets.
- Use the platform's own notation. GitLab: `!1234`. GitHub: `#1234`. Do not
  mix them. Add the full link only when the user asks for links.
- Add the issue number when the MR closes or links one: `closes #1711`.
- End a feature with a check line when it is real: `Type check and lint
  pass.`, `497 Jest tests pass.`, `Added 5 unit tests.` Never claim a check
  that was not run.
- If work is blocked or waiting, say so in one line: `Waiting for the
  reviewer's approval.`, `Depends on the backend endpoint.`
- A short `Reviews:` group lists the MRs reviewed and the one notable finding.
- Put non-code items (meetings, environment, blockers) last, in the same terse
  style.

## Worked example 1 (feature with cause and fix)

```markdown
EOD STATUS:

- Overview scoped to the selected tenant (!3122, merged)
  - Changing the tenant in the sidebar now reloads the overview widgets for that tenant. The widgets send the chosen tenant to the backend.
  - The tenant choice now lives in one shared context. A new hook picks the tenant: the saved one, else the default, else the first.
  - The six widgets and their data hooks pass the tenant. A tenant switch causes a refetch.
  - Type check and lint pass. 497 tests pass.
```

## Worked example 2 (bug with symptom, cause, fix)

```markdown
EOD STATUS:

- Agents page fixes (branch `fix/agents-page`)
  - The page sent the same list request twice, about 1 s apart. I replaced three effects with one. It fetches once when the filter or sort changes, and it goes back to page 1.
  - Responses from older requests are now ignored. A failed request shows an error toast.
  - A stray semicolon in the CSP header ended the `frame-ancestors` list early. The browser logged an invalid directive error. Removed it.
  - Type check and lint pass.
```

## Worked example 3 (several MRs, one short bullet each)

```markdown
EOD STATUS:

- Policy pages loading state (!3066)
  - Pages now show a skeleton while loading. Before, they flashed a placeholder badge and fixed title text.
- Chart labels (!3067)
  - X-axis labels were clipped. The label width now follows the bar width, so the full name or an ellipsis with a tooltip shows.

Blocked:

- Waiting for the backend endpoint before the UI part can start.
```

## What NOT to do

- Do not paste commit messages 1:1. Say what the change did.
- Do not write one bullet for each commit.
- Do not invent detail that the diff does not support.
- Do not write vague bullets ("various fixes", "minor cleanup"). Name the
  fix.
- Do not write about a test or check that was not run.
- Do not put real customer, company, or teammate names in this file or its
  examples. Keep those in the live status shown to the user only.

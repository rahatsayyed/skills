---
name: open-gitlab-mr
description: Create or update a GitLab merge request from the current branch, with a conventional-commit title and a structured description written from the real diff. Use when the user asks to raise/open/create an MR, submit changes for review, push a branch and open it, or refresh an existing MR's title/description ("raise MR", "open MR", "MR please").
---

# Open GitLab MR

Reads the branch diff, writes a conventional-commit title and a structured
description, and creates (or updates) the GitLab MR.

## Settings (resolve once, never hardcode)

| Setting | How to resolve |
| --- | --- |
| Project | Parse `git remote get-url origin` into `group/subgroup/project` |
| Target branch | User's choice, else the project's default branch: `git symbolic-ref --short refs/remotes/origin/HEAD` (strip `origin/`) |
| Assignee | The current GitLab user (`get_user` with no args, or `glab api user`) |
| Reviewer | Only if the user names one. Otherwise leave unset. |
| Squash / delete source branch | On by default. Turn off only if the user says so. |

If the user keeps a project-specific defaults note (CLAUDE.local.md, memory), those
override the table.

Below, `$BASE` is the target branch.

## Step 1: Pre-flight

1. Commits exist: `git log $BASE..HEAD --oneline`. If empty, stop and tell the user there is nothing to raise.
2. Branch is pushed: `git status -sb`. If there is no upstream, run `git push -u origin HEAD`.
3. Tests: if the project has an obvious fast test/lint target relevant to the changed paths (Makefile target, `package.json` script, CI job), run it. If it fails, stop and report. Do not open an MR on a failing suite. If nothing obvious exists, skip and say so in "How it was tested".

## Step 2: Gather the diff

```bash
git diff $BASE...HEAD --stat
git diff $BASE...HEAD
git log $BASE..HEAD --oneline
```

Use all three: which files changed, what the logical changes are, how the work evolved.

## Step 3: Ticket references

Collect unique issue numbers from, in priority order:

1. Branch name (`user-fix-1234` or `1234-fix-thing` gives `#1234`)
2. Commit messages (`#NNN`, `closes #NNN`, `fixes #NNN`)
3. The user's message

Use `Closes #NNN` if the MR resolves it, `Related: #NNN` for partial work. None found: omit. Never invent.

## Step 4: Classify the change

- **Scope**: derive from top-level directories touched (e.g. `web/`, `backend/`, `infra/`). Use the feature or module name as the commit scope.
- **Visual**: true if the diff touches UI markup, styles, layout, component structure, or design tokens (`.tsx`, `.vue`, `.css`, Tailwind classes). Drives the Screenshots section.

## Step 5: Title

`type(scope): short description`

- **type**: `feat`, `fix`, `refactor`, `chore`, `test`, `docs`
- **scope**: lowercase kebab-case module/feature (`auth`, `billing-export`)
- **description**: one short sentence, lowercase, no trailing period. Whole title about 72 chars max.

Good: `feat(users): add active-users hero-stats endpoint`
Bad: `Updated some files and fixed stuff`

Prefix `Draft: ` if the user says draft or WIP.

## Step 6: Description

Use this template. Drop a section only if it truly has nothing to say. Never leave placeholder text.

```markdown
Closes #NNN   <!-- or "Related: #NNN"; omit if no ticket -->

<1-3 sentences: what this MR does and why it matters. Outcome, not mechanics.>

---

## What changed
<Specific bullets: files, new functions/endpoints/components, removals, renames.>

## Why it changed
<The problem: what was broken, missing, or suboptimal. Bug report, design decision, requirement.>

## How it was tested
<Honest account: tests added/run, lint/type checks, manual steps.>

## Risks or special considerations
<Breaking changes, migrations, env vars, edge cases, follow-ups. If none: "None identified.">

## Behaviour changes
<User- or API-visible changes. If pure refactor: "None. Internal refactor only.">

## Screenshots
<See below>
```

**Screenshots**:
- Visual change: `_Add updated screenshots here. Run the app and capture the affected view._`
- Otherwise: `No design / layout / style changes.`

Never write the "no changes" line when visual files changed.

## Step 7: Create the MR

Use the GitLab MCP MR tool (`save_merge_request` / `create_merge_request`), or `glab mr create` if MCP is unavailable:

```json
{
  "project_id": "<from Settings>",
  "title": "<Step 5>",
  "description": "<Step 6>",
  "source_branch": "<current branch>",
  "target_branch": "<$BASE>",
  "assignee": "<current user>",
  "reviewers": ["<only if named>"],
  "squash": true,
  "remove_source_branch": true
}
```

## Step 8: Report

Give the MR title and URL. Add a one-line note if Screenshots needs manual images.

## Updating an existing MR

When an MR already exists for the branch:

1. Find it by `source_branch` (list merge requests) to get its `iid` and current description.
2. Collect every image/attachment reference in the current description (`![...](...)`, `/uploads/...`). **Never discard these.**
3. Rewrite title and description from the current diff (Steps 2-6).
4. Put all collected attachments at the **end** of `## Screenshots`, in original order.
5. Call the update MR tool with the new `title` and `description`.

## Edge cases

- **Different target branch**: use the user's choice over the default.
- **Different reviewer**: use whoever the user names.
- **Nothing committed**: stop and ask the user to commit first.
- **Attachments**: never delete or move existing images or uploads.

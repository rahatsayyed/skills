---
name: standup
description: Generate an EOD/standup status update from your own GitLab activity (commits, diffs, and MR reviews) over a given time period. Use when the user asks for their EOD status, daily/weekly standup update, or "what did I do today/this week on GitLab".
---

# Standup / EOD Status

Builds an EOD status update from real GitLab activity: your commits, what those
commits actually changed (via diffs), and any merge requests you reviewed —
grouped by feature/MR, in prose, not a raw commit-log dump.

## When to use

- User asks "write my EOD status" / "generate my standup update" / "what did I
  ship today"
- User wants a status covering "today", "yesterday", "this week", or an
  explicit date range

## Inputs needed before running

1. **GitLab identity.** Check existing memory (the auto-memory system) for a
   saved `gitlab_username` and default project/group. If missing, ask the
   user once for their GitLab username, then save it as a `reference` memory
   ("GitLab username for the standup skill") so future runs skip this
   question. Do not guess it, and do not write it into any file inside this
   skill's own folder — this skill is installed from a marketplace/plugin
   source, and files written inside the installed package can be wiped on
   the next update or reinstall. Memory lives outside that package, so it
   survives updates.
2. **Time period.** Default to "since the start of today" (local time) unless
   the user names a period ("yesterday", "this week", "since Monday",
   explicit dates). Convert relative periods to absolute datetimes before
   calling any tool.
3. **Project/group scope.** Use a project the user names, or the one most
   recently discussed in conversation. If neither is known, ask which
   project(s) to pull from — do not silently scan every project the user has
   access to.

## Steps

1. **Pull commits.** Call `mcp__claude_ai_gitlab__list_commits` for the
   scoped project(s), filtered to the user's identity and time window.
2. **Pull diffs for context.** For each commit (or, better, each branch/MR
   cluster of commits), call `mcp__claude_ai_gitlab__get_commit` to see the
   actual diff — do not summarize from commit messages alone. Commit messages
   are often terse or wrong; the diff tells you what really changed and why
   it matters.
3. **Group by feature/MR, not by commit.** Match commits to their merge
   request via `mcp__claude_ai_gitlab__list_merge_requests` /
   `get_merge_request` (scoped to the user as author, same time window).
   Each MR becomes one section of the status, not one line per commit.
4. **Pull review activity.** Call `mcp__claude_ai_gitlab__list_merge_requests`
   (scoped to the user as reviewer/approver) and
   `get_merge_request_notes`/`get_merge_request_diffs` for MRs the user
   reviewed or commented on in the window. Summarize what was reviewed and
   any notable finding — don't just list MR numbers.
5. **Ask for anything GitLab can't see.** Meetings, customer calls, blockers,
   non-code work, and laptop/environment issues never show up in commits.
   Ask the user once: "Anything outside GitLab to add — meetings, calls,
   blockers?" Fold their answer in as its own section, written the same way
   as the rest (short factual bullets/prose), before finalizing.
6. **Write the status.** Follow [references/style-guide.md](references/style-guide.md)
   for tone and structure. Rephrase into plain first-person, past-tense
   engineering prose — never paste raw commit messages or diff hunks
   verbatim. Include MR links for anything merged, in review, or noteworthy.

## Output

Header `EOD STATUS:` (or `EOD Status:` — match whichever the user used most
recently), then grouped sections. See
[references/style-guide.md](references/style-guide.md) for the exact shape
and worked (anonymized) examples.

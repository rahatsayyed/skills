---
name: standup
description: Generate an EOD/standup status update from your own GitLab or GitHub activity (commits, diffs, and MR/PR reviews) over a given time period. Use when the user asks for their EOD status, daily/weekly standup update, or "what did I do today/this week on GitLab/GitHub".
---

# Standup / EOD Status

Builds an EOD status update from real GitLab or GitHub activity: your commits,
what those commits actually changed (via diffs), and any merge/pull requests
you reviewed — grouped by feature/MR/PR, in prose, not a raw commit-log dump.

## When to use

- User asks "write my EOD status" / "generate my standup update" / "what did I
  ship today"
- User wants a status covering "today", "yesterday", "this week", or an
  explicit date range

## Inputs needed before running

1. **Platform.** Figure out GitLab vs. GitHub before anything else:
   - Check existing memory (the auto-memory system) for a saved platform +
     username (e.g. `gitlab_username` or `github_username`) and default
     project/repo.
   - If missing and the current working directory is a git repo, infer it
     from `git remote -v` (a `gitlab.com`/self-hosted GitLab host vs.
     `github.com`).
   - If still ambiguous (both are plausible, or memory/remote disagree with
     what the user is asking about), ask once. Don't guess silently.
   - Once known, save it as a `reference` memory ("<platform> username for
     the standup skill") so future runs skip this question. Never write it
     into a file inside this skill's own folder — this skill is installed
     from a marketplace/plugin source, and files written inside the
     installed package can be wiped on the next update or reinstall. Memory
     lives outside that package, so it survives updates.
2. **Time period.** Default to "since the start of today" (local time) unless
   the user names a period ("yesterday", "this week", "since Monday",
   explicit dates). Convert relative periods to absolute datetimes before
   calling any tool.
3. **Project/repo scope.** Use a project/repo the user names, or the one most
   recently discussed in conversation. If neither is known, ask which one(s)
   to pull from — do not silently scan every project/repo the user has
   access to.

## Steps

Use whichever tools are available for the identified platform. If an MCP
server for that platform is connected, use it — GitLab's `list_commits` /
`get_commit` / `list_merge_requests` / `get_merge_request` /
`get_merge_request_notes` tools (`mcp__claude_ai_gitlab__*` in this build) are
confirmed available; look up the GitHub equivalents the same way (`ToolSearch`
for "github commits", "github pull request", etc. — names vary by which
GitHub MCP server is connected). If no MCP server is connected for the
platform, fall back to the CLI via Bash: `glab` for GitLab, `gh` for GitHub.

1. **Pull commits.** List commits for the scoped project/repo, filtered to
   the user's identity and time window.
2. **Pull diffs for context.** For each commit (or, better, each branch/MR/PR
   cluster of commits), fetch the actual diff — do not summarize from commit
   messages alone. Commit messages are often terse or wrong; the diff tells
   you what really changed and why it matters.
3. **Group by feature/MR/PR, not by commit.** Match commits to their merge or
   pull request (scoped to the user as author, same time window). Each
   MR/PR becomes one section of the status, not one line per commit.
4. **Pull review activity.** List merge/pull requests scoped to the user as
   reviewer/approver, and pull the review notes/comments for ones the user
   reviewed or commented on in the window. Summarize what was reviewed and
   any notable finding — don't just list MR/PR numbers.
5. **Ask for anything the platform can't see.** Meetings, customer calls,
   blockers, non-code work, and laptop/environment issues never show up in
   commits. Ask the user once: "Anything outside GitLab/GitHub to add —
   meetings, calls, blockers?" Fold their answer in as its own section,
   written the same way as the rest (short factual bullets/prose), before
   finalizing.
6. **Write the status.** Follow [references/style-guide.md](references/style-guide.md)
   for tone and structure. Rephrase into plain first-person, past-tense
   engineering prose — never paste raw commit messages or diff hunks
   verbatim. Include MR/PR links for anything merged, in review, or
   noteworthy, using the platform's own vocabulary (MR/`!1234` for GitLab,
   PR/`#1234` for GitHub) in the final write-up.

## Output

Header `EOD STATUS:` (or `EOD Status:` — match whichever the user used most
recently), then grouped sections. See
[references/style-guide.md](references/style-guide.md) for the exact shape
and worked (anonymized) examples.

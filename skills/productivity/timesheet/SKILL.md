---
name: timesheet
description: Fill the user's own row in a Google Sheets monthly timesheet for a given date, using the EOD status text from the standup skill. Use when the user asks to "update my timesheet", "fill the sheet for today", or after the standup skill finishes an EOD status.
---

# Timesheet

Writes a one-line work description for one date into the user's own block of a
monthly Google Sheets timesheet. It reuses the EOD status from the `standup`
skill, so the user does not write the same thing twice.

## When to use

- The user asks to update or fill the timesheet for a date or a date range.
- The `standup` skill just produced a final EOD status and the user said yes
  to the timesheet offer.

## Inputs needed before running

1. **Sheet details.** Read them from the auto-memory system (a `reference`
   memory about the timesheet). They are:
   - the spreadsheet ID
   - the tab name pattern (for example `<Month> <Year>`)
   - which columns hold the date, the description and the hours for the
     user's own block
   - which other blocks in the sheet belong to other people and must not be
     touched
   If a detail is missing, ask once, then save it as a `reference` memory.
   Never write these details into a file in this skill's folder. This repo
   can be public, and the installed package can be wiped on update.
2. **Date.** Default to today (local time). Convert words like "yesterday" to
   an absolute date first.
3. **EOD text.** Use the final status from this conversation for that date.
   If there is none, run the `standup` skill for that date first. Do not
   invent work.

## Steps

Use the Google Sheets MCP tools (`read_range`, `write_range`). If they are not
connected, stop and tell the user which tool is missing.

1. **Find the tab and the row.** Read the date column of the month tab. Match
   the date in the format the sheet uses (for example `11/12/2026`). Do not
   compute the row number from the day number. Find it by value.
2. **Skip non-working days.** If the description cell says `Weekend` or
   `HOLIDAY`, or the hours cell is 0, do not write. Tell the user why.
3. **Check the cell.** If the description cell already has text, show it and
   ask before you overwrite it.
4. **Condense the EOD.** Turn the status into one line. Rules:
   - One cell, no line breaks. Separate items with `; `.
   - Group by feature. Keep MR numbers (`!1234`). Drop the state words and the
     check lines (tests, lint) unless they are the main work.
   - Keep the real names of features and components. Keep it under about 300
     characters.
   - Plain words. Same facts as the EOD. Add nothing new.
5. **Write only the description cell.** Use `write_range` on that one cell.
   Do not write the hours cell. Do not write to any other person's block.
6. **Verify.** Read the cell back. Show the user the date, the cell address and
   the text that was written.

## Date ranges

For a range, repeat steps 1 to 6 for each working day. Use the work for that
day only. Do not copy one day's text to another day. If you have no data for a
day, leave it empty and list it for the user at the end.

## Output

Markdown. A short list of what was written: date, cell, text. Then a list of
skipped days with the reason (weekend, holiday, no data, already filled).

# ADR 0001: Store team data as plain text instead of structured format

**Status:** Accepted

**Context:**
Team Directory needs to persist a list of team members (name and role) that can be read and searched by the script. Options considered were a plain text file, a CSV file, or a JSON file. This is a small, single-file tool built as a Git fundamentals exercise, not a production system with an existing data pipeline.

**Decision:**
Store team member data in a plain text file (`team.txt`), with each entry as free-form lines (`Name: X`, `Role: Y`), read directly by PowerShell's `Get-Content` and filtered with `Where-Object`.

**Consequences:**
- Positive: No parsing library or schema needed — the file is human-readable and trivially editable by hand.
- Positive: Keeps the tool dependency-free, matching the scope of a Git fundamentals exercise.
- Negative: No validation or schema enforcement — malformed lines fail silently rather than raising a clear error.
- Negative: Harder to extend later (e.g. adding an email field) without restructuring how every line is parsed.
- If this tool grows beyond a learning exercise, migrating to structured JSON or CSV would be the natural next step, since it would enable safer parsing and easier extension.
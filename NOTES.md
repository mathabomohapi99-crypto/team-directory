# NOTES.md — Assignment 1.1

## Part 1 — Written Decisions

### Question 1 — What is worth its own commit?

**Category A — high-value commit boundaries**
- Adding the main script — lets a reviewer see exactly when the tool's core logic was introduced, and revert it alone if needed
- Adding the data file — a separate concern from the logic that reads it; isolating it makes git blame meaningful
- Wiring the script to the data — this is a real behaviour change, not just file creation, so it deserves its own commit
- Adding .gitignore — a config decision that's easy to trace later if a file leaks into history that shouldn't have
- Each new feature (e.g. search/filter) — so it can be reverted on its own if it breaks something, without touching unrelated work

**Category B — changes NOT worth a separate commit**
- A typo fix seconds after the commit that introduced it — bundling it back in avoids cluttering history with noise; splitting it out gains nothing since nobody needs to `git blame` a typo separately
- Whitespace-only reformatting — same reasoning: it adds a commit with zero meaningful content, making the log harder to scan
- A console.log added and removed in the same sitting — it never actually shipped, so it never needs to exist in history at all

**Category C — .gitignore scope**
I'm ignoring `.env` (a dummy secret file) and `*.log` (output/log file). If `.env` was committed and later needed to be removed, a teammate would lose more than just deleting the file — the secret would still exist in every past commit's history, so it would need to be scrubbed from the entire git history (not just deleted), and the exposed secret would need to be rotated/invalidated regardless, since anyone who cloned the repo already has it.

### Question 2 — Merge vs. rebase

- **Merge** preserves the true shape of history: you can see exactly when and how the branches diverged and rejoined, via a merge commit. It discards nothing, but produces a "diamond" shape in the graph.
- **Rebase then fast-forward** rewrites the branch's commits to sit on top of the latest main, producing a straight, linear history. It discards the true record of *when* the branch actually diverged from main — chronologically it looks like the work happened later than it did.

For Part 3's intentional conflict, I'll use a **merge**, because I want the commit graph to visibly preserve the fact that a real conflict happened and was resolved, rather than rewriting it away.

### Question 3 — Remote operations inventory

- `git remote add origin <url>` — configures where my local repo points on GitHub (no network call yet)
- `git push -u origin main` — sends my local commits to GitHub and sets up branch tracking; I expect to see my commits and branch appear on GitHub
- `git push` — sends any new local commits; I expect GitHub's commit list to match mine afterward
- `git push -u origin <branch>` — pushes a feature branch with tracking; I expect a new branch to appear on GitHub, along with a "Compare & pull request" prompt
- `git pull --rebase origin main` — fetches GitHub's latest commits and replays my local commits on top; I expect my branch to update locally without a merge commit

**What pushing to GitHub cannot verify:** whether my code actually runs correctly. Git only checks that my commit history is valid and can be applied — it has no idea if `dotnet run` succeeds or if a function does what its comment says. A commit can push cleanly and still contain broken code. That's exactly the gap the CI check in Part 5 is meant to catch instead.

### Question 4 — Commit message as specification

a. "fixed stuff" — implementation minutiae / too vague. Rewrite: "Fix crash when team list is empty"
b. "Update index.js" — vague, describes location not behaviour. Rewrite: "Add sorting to team member list"
c. "WIP" — not a real message, describes nothing. Should be replaced with the actual final behaviour once the work is done, e.g. "Add search function for team members"
d. "Add email format validation so invalid addresses cannot be submitted" — already good: imperative mood, describes behaviour and intent. No change needed.
e. "asdasd" — meaningless. Rewrite based on what actually changed, e.g. "Correct spelling in README"
f. "Changed line 47 of notes.md" — implementation minutiae, references a line number instead of intent. Rewrite: "Clarify setup instructions in NOTES.md"
## Part 3 — git diff observations

**Diff 1 (before committing "Add function to read team data file"):**
Running `git diff team.ps1` showed the new `Get-TeamMembers` function being added (lines with `+`), while the existing `Write-Host` line stayed unchanged. This confirmed I was only adding the function and not accidentally modifying anything else before I staged it.

**Diff 2 (before committing "Wire team script to read and display team data"):**
Running `git diff team.ps1` showed a blank line added after the first line, plus the new `$members = Get-TeamMembers` and `foreach` loop being added at the bottom (all with `+`). Seeing this before committing let me confirm the wiring code was exactly what I intended, and that I hadn't left the earlier skeleton code broken.
## Part 3 — Task 4 (merge type)

Merging `feature/add-search` into `main` produced a **fast-forward**, not a three-way merge. I knew this because the terminal output literally said "Fast-forward" instead of opening a merge commit message editor. This happened because `main` hadn't received any new commits since I branched off it — so git could just move the `main` pointer straight up to my branch's latest commit, with no divergence to reconcile.
## Part 3 — Task 7 (conflict explanation)

The conflict happened because I edited the same line of README.md on two different branches — once on `edit-readme`, and once directly on `main` — with different text each time. Git couldn't automatically decide which version was correct since both were valid edits to the exact same line, so it stopped and asked me to choose. I resolved it by combining both intentions into one final line, `# Team Directory CLI Tool (by Mathabo)`, rather than picking one side and discarding the other's idea entirely.
## Part 3 — Task 9 (merge vs rebase graph comparison)

Looking at `git log --oneline --all --graph`, Task 4's merge (the search feature) shows the same straight shape as a fast-forward, but Task 6/7's conflict merge clearly shows a diamond — two lines diverging from a common commit and rejoining at a merge commit with two parents. Task 9's rebase, by contrast, shows no diamond at all — the branch's commit sits as a single straight line directly on top of main's latest commit, because rebase rewrote it to look like it happened after main's other commits, rather than alongside them.

I'd choose a **merge** when I want the true history preserved — e.g. on a shared team branch, where rewriting commits others have already pulled would break their local copies. I'd choose **rebase** for my own local feature branch before it's shared with anyone, to keep the final history clean and easy to read.
## Part 4 — Rejected push recovery

When I tried to push after editing README.md directly on GitHub's website, my push was rejected with: `! [rejected] main -> main (fetch first)`, because the remote had a commit I didn't have locally yet. I recovered using `git pull --rebase origin main` instead of a plain `git pull` or a force-push. A plain `pull` would have created an unnecessary merge commit for two unrelated, non-conflicting changes, and force-pushing would have overwritten the teammate's (in this case, my own web-edit) commit on GitHub entirely, destroying their work. `pull --rebase` replayed my local commit cleanly on top of the remote's commit, preserving both changes with a clean, linear history — the correct recovery, not just the safest-sounding one.

## Assignment 1.2

### Question 1 — Why fork, not branch, this time?

In 1.1 I had write access to my own repo, so branching directly made sense. This time I don't have write access to my partner's repo, so I can't push a branch there directly — GitHub would just reject it. Forking gives me my own copy of their repo where I do have write access, and lets me open a Pull Request from my copy back into theirs. If I tried to clone their repo and push a branch straight to it, the push would fail with a permissions error, since I'm not a collaborator on it.

## Question 2 — PR description: bad vs. good

Bad version:

"added search"

Good version:

What: Added a Search-TeamMembersByRole function to team.ps1 that lets a user search team members by role.
Why: The directory only supported searching by name. Teams often need to find everyone in a given role (e.g. all Backend Developers), so this fills a real gap.
How to verify: Run .\team.ps1, enter a role like "Developer" when prompted, and confirm it prints only matching entries.

## Question 3 — Triaging review comments

A blocking comment is something that must be fixed before merge — a bug, a missing case, or something that would break for other users. A nit/suggestion is a preference that doesn't affect correctness, like naming or formatting — nice to have, not required. A question is the reviewer asking for clarification, not necessarily asking for a change.

My rule: if the comment points out something that would cause incorrect behavior or a real gap, I treat it as blocking. If it's about style, naming, or "could also do it this way," I treat it as a nit. If it's phrased as "why did you..." or "what happens if...", I treat it as a question until it's clear whether they expect a change.

## Question 4 — When fetch beats pull

After my partner's PR is merged into my repo, before pulling I'd run git fetch and check origin/main first, rather than pulling straight away. This lets me see exactly what changed and confirm the merge commit is there with my partner's name as the author, before it touches my local main. If I just ran pull blindly, I'd merge it in immediately without ever having looked at what I was about to bring in — fine most of the time, but risky if there's ever a conflict or something unexpected upstream.

## Reflections

### 1. What I contributed, and why

I added a `Search-TeamMembersByRole` function to my partner's `team.ps1`, allowing users to search for team members by their role instead of only by name. I considered this a useful contribution because the existing tool could search by name, but there was no way to quickly find everyone in a particular role, such as Backend Developers. This makes the directory more useful as the team grows.

### 2. A comment I received that changed my code

My partner left a blocking comment on my Pull Request pointing out that I had a duplicate and incomplete `## Assignment 1.2` section in my `NOTES.md`. This happened after changes from `main` were brought into my branch and caused duplicate content. I fixed the issue by removing the duplicate section and keeping the complete version of my Assignment 1.2 answers. I made the correction in a follow-up commit rather than amending or force-pushing the original commit.

### 3. A comment I gave that I stand by

On my partner's Pull Request, I left a blocking comment about the `get_entries()` function. I pointed out that the function could fail with an unhandled exception if `team.txt` was missing or could not be read, and suggested handling the error with a clear message instead. I stand by this comment because it was a genuine reliability issue that could affect the user of the program, rather than just being a personal preference about style or formatting.

### 4. Fetch vs. pull, in practice

In my original 1.1 repository, I ran `git fetch` before pulling and saw that `origin/main` was ahead of my local `main`. I then used `git log --oneline main origin/main` to inspect the incoming history before changing my local branch. After confirming the merged changes from my partner were present, I ran `git pull`, which fast-forwarded my local `main`. This showed me the practical value of using `fetch` first: I could inspect what had changed on the remote before bringing those changes into my local branch.

### 5. What I learned from the workflow

The biggest thing I learned from Assignment 1.2 was how a fork-based workflow allows people to contribute to a repository even when they do not have direct write access. I also learned that Pull Requests are not only for submitting code, but are an important part of reviewing, discussing, and improving changes before they are merged.

I also learned the importance of responding to review feedback with follow-up commits instead of changing the original commit history. The process of reviewing my partner's Pull Request also showed me the difference between a blocking issue, a suggestion, and a question.

One process mistake I made was merging my partner's Pull Request before completing my review. I corrected this by reviewing the merged Pull Request afterward and documenting what happened. In future, I will make sure to complete the review and submit my review decision before merging a Pull Request.

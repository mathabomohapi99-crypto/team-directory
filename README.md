# Team Directory

A simple command-line tool for viewing and searching a team member directory, built in PowerShell.

## Purpose

This tool reads team member data from a plain text file and lets you list all members, and search by name or role, directly from the terminal. It was built as a Git fundamentals exercise but works as a lightweight reference tool for small teams without needing a database or external dependencies.

## Setup

1. Clone this repo:

git clone https://github.com/mathabomohapi99-crypto/team-directory.git
cd team-directory

2. No dependencies to install — this only requires PowerShell (built into Windows, or install PowerShell 7+ on macOS/Linux).
3. Ensure `team.txt` is present in the same folder as `team.ps1` (it should be, after cloning).

## Usage

Run the script from the repo folder:

.\team.ps1


This will:
- Print the total number of team members
- List every member with their name and role
- Prompt you to search by name (press Enter to skip)
- Prompt you to search by role (press Enter to skip)

**Example — searching by role:**

Enter a role to search (or press Enter to skip): Backend Developer
--- Role search results ---
Name: Quinton Fykels
Role: Backend Developer


## Known Limitations

- Team data is stored in a single plain text file (`team.txt`) with no validation — malformed entries can silently break search results.
- No concurrent-access handling — if multiple people edit `team.txt` at the same time, changes can be lost.
- Search assumes `team.txt` lines strictly follow the `Name: X` / `Role: Y` format; other formats will return no results with no error message.

## Contribution Guide

1. Fork this repo and create a branch off `main` (e.g. `feature/add-email-field`).
2. Make your changes and test by running `.\team.ps1` locally.
3. Commit with a clear message describing what changed and why.
4. Open a pull request against `main` and describe your change in the PR description.
5. Wait for review before merging — do not merge your own PRs directly.
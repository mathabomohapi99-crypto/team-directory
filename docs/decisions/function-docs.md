# Function Documentation

## Search-TeamMembersByRole

**Description:**
Searches the team directory for all members matching a given role, using a partial (substring) match rather than an exact match.

**Location:** `team.ps1`

**Inputs:**
| Parameter | Type   | Required | Description                                  |
|-----------|--------|----------|-----------------------------------------------|
| `role`    | string | Yes      | The role (or partial role name) to search for |

**Output:**
Returns zero or more matching lines from `team.txt`, each formatted as:

Name: <name>
Role: <role>

If no members match, returns nothing (empty result) rather than an error or message.

**Error cases:**
- If `$role` is empty or not provided, the function still runs but effectively matches every line containing "Role:", returning the entire team list instead of a meaningful filtered result — this is a known gap, not explicit error handling.
- If `team.txt` is missing or unreadable, the underlying `Get-TeamMembers` call will throw a file-not-found error, since there is no try/catch around the file read.

**Example usage:**
```powershell
Search-TeamMembersByRole -role "Developer"
```
Returns all entries where the role contains "Developer" (e.g. "Backend Developer", "Frontend Developer").
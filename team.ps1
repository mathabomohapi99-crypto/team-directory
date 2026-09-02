Write-Host "=== Team Directory ==="

function Get-TeamMembers {
    Get-Content -Path "team.txt"
}

$members = Get-TeamMembers
$count = (Get-TeamMembers).Count
Write-Host "Total members: $count"
function Search-TeamMembers {
    param($name)
    Get-TeamMembers | Where-Object { $_ -like "*$name*" }
}
foreach ($member in $members) {
    Write-Host $member
}

$searchName = Read-Host "Enter a name to search (or press Enter to skip)"
if ($searchName) {
    Write-Host "--- Search results ---"
    Search-TeamMembers -name $searchName
}

function Search-TeamMembersByRole {
    param($role)
    Get-TeamMembers | Where-Object { $_ -like "*Role:*$role*" }
}
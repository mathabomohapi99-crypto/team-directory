Write-Host "=== Team Directory ==="

function Get-TeamMembers {
    Get-Content -Path "team.txt"
}

$members = Get-TeamMembers
foreach ($member in $members) {
    Write-Host $member
}
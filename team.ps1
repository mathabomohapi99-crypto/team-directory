Write-Host "=== Team Directory ==="

function Get-TeamMembers {
    Get-Content -Path "team.txt"
}

$members = Get-TeamMembers
function Search-TeamMembers {
    param($name)
    Get-TeamMembers | Where-Object { $_ -like "*$name*" }
}
foreach ($member in $members) {
    Write-Host $member
}
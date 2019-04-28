[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWMICmdlet", "", Justification = "Don't tell me what to do.")]

$admins = Get-WmiObject -Class win32_groupuser | Where-Object { $_.groupcomponent -like '*"Administrators"' }

$users = @()
# omg not my code
$admins | ForEach-Object {
    $_.partcomponent -match ".+Domain\=(.+)\,Name\=(.+)$" > $nul
    $match = $null
    $match = $matches[1].trim('"') + "\" + $matches[2].trim('"')
    $users += $match
}

$users | ConvertTo-Json
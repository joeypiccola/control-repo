[CmdletBinding()]
Param (
    [Parameter()]
    [String[]]$NotKBArticleID
)

$oi = Get-Random -Minimum 1000000 -Maximum 9999999
$blah = [PSCustomObject]@{
    NotKBArticleID = $NotKBArticleID
}

$json = $blah | convertto-json
Add-Content -Path "C:\deploy\$oi`_json.txt" -Value $json -Force
start-sleep -Seconds 100
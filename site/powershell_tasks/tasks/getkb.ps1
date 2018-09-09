Param (
    [Parameter()]
    [string]$kb
)

try {
    $kb_query = Get-HotFix -Id $kb
} catch {
    Write-Information "$kb was not found"
}

if (!$kb_query) {
    try {
        $kbid = $kb.Split('b')[1]
        $kb_query = Get-HotFix -Id $kbid
    } catch {
        Write-Information "no kb found for $kbid"
    }
}

if ($kb_query) {
    Write-Output ($kb_query | Select-Object @{Name = "Source"; Expression = {$_.CSName}}, Description, HotFixID, InstalledBy, @{Name = "InstalledOn"; Expression = {$_.InstalledOn.datetime}} | ConvertTo-Json -Depth 1)
} else {
    Write-Output "$kb not found."
}
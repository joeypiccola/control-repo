[CmdletBinding()]
Param (
    [Parameter(Mandatory)]
    [string]$kb
)

# deifine pref vars
$ErrorActionPreference = "Stop"

# make kb lowercase
$kb = $kb.ToLower()

# from the provided input generate kb vars of both (KB123) and (123)
if ($kb.Substring(0, 2) -eq 'kb') {
    $kbid = $kb.split('b')[1]
} else {
    $kbid = $kb
    $kb = 'kb' + $kb
}

# try and search for kb
try {
    Write-Verbose "Trying to search for $kb."
    $getHotFix = Get-HotFix -Id $kb -ErrorAction Stop
} catch [System.ArgumentException] {
    Write-Verbose "$kb was not found."
} catch {
    Write-Error $_.Exception.Message
}

# if we didn't find the kb try and search for the kbid
if (!$getHotFix) {
    try {
        Write-Verbose "Trying to search for $kbid."
        $getHotFix = Get-HotFix -Id $kbid -ErrorAction Stop
    } catch [System.ArgumentException] {
        Write-Verbose "$kbid was not found."
    } catch {
        Write-Error $_.Exception.Message
    }
}

if ($getHotFix) {
    Write-Output ($getHotFix | Select-Object @{Name = "Source"; Expression = { $_.CSName } }, Description, HotFixID, InstalledBy, @{Name = "InstalledOn"; Expression = { $_.InstalledOn.datetime } } | ConvertTo-Json -Depth 1)
} else {
    Write-Output $false
}

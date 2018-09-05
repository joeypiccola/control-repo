[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "", Justification="just can't fix this")]

[CmdletBinding()]
Param (
    [Parameter()]
    [String[]]$NotKBArticleID
)

#region logic
# setup logging
$logName = 'ISG Windows Update'
$source = 'Windows Update'
try {
    Get-EventLog -LogName $logName -ErrorAction SilentlyContinue
} catch {
    New-EventLog -LogName $logName -Source $source
    Write-EventLog -LogName $logName -Source $source -EntryType Warning -EventId 10 -Message "Event Log $logName does not exist, creating it."
}

# verify dependencies
$modules = Get-Module -Name 'PSWindowsUpdate' -ListAvailable
if ($modules) {
    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 20 -Message "$($modules.count)x version(s) of PSWindowsUpdate found on local system."
    foreach ($module in $modules) {
        Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 21 -Message "$($module.Name) v$($module.Version) found on local system."
    }
} else {
    Write-EventLog -LogName $logName -Source $source -EntryType Error -EventId 22 -Message "The PowerShell module PSWindowsUpdate not found."
}

# get missing updates
Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 23 -Message "Initiating Windows Update scan."
$updates = Get-WindowsUpdate -NotKBArticleID $NotKBArticleID
if ($updates.count -gt 0) {
    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 24 -Message "$($updates.count)x updates missing."
    foreach ($update in $updates) {
        Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 25 -Message "KB: $($update.KB)`n`Title: $($update.Title)`n`Size: ($($update.Size))`n`Status: Missing"
    }
} else {
    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 26 -Message "$($updates.count)x updates missing."
}
#endregion

if ($updates.count -gt 0) {
    $windowsUpdateParams = @{
        AcceptAll       = $true
        Download        = $true
        Install         = $true
        IgnoreReboot    = $true
        IgnoreUserInput = $true
        Confirm         = $true
        NotKBArticleID  = $NotKBArticleID
    }
    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 28 -Message "$($updates.count)x updates missing. Installing Windows Update."
    Get-WindowsUpdate @windowsUpdateParams | ForEach-Object {
        Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 29 -Message "KB: $($_.KB)`n`Title: $($_.Title)`n`Size: $($_.Size)`n`Result: $($_.Result)`n"
    }
    $patch_fact = [PSCustomObject]@{
        LastPatched = "$(Get-Date)"
    }
    $factContent = $patch_fact | ConvertTo-Json
    $factPath = 'C:\ProgramData\PuppetLabs\facter\facts.d\patching.json'
    # force UTF8 with no BOM to make facter happy (Out-File -Encoding UTF8 does not work, Add-Content does not work, >> does not work)
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($factPath, $factContent, $Utf8NoBomEncoding)
    shutdown /r /t 10 /f /d p:4:1 /c "Windows Update Restart"
    Start-Sleep -Seconds 10
} else {
    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 27 -Message "$($updates.count)x updates missing. Exiting Windows Update."
}
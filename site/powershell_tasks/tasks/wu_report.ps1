# Represents a session in which the caller can perform operations that involve updates.
$session = New-Object -ComObject 'Microsoft.Update.Session'
# Returns an IUpdateSearcher interface for this session.
$updateSearcher = $session.CreateUpdateSearcher()
# Gets and sets a ServerSelection value that indicates the server to search for updates. 1 is ssManagedServer.
$updateSearcher.ServerSelection = 1
try {
    # Performs a synchronous search for updates. The search uses the search options that are currently configured.
    # "IsInstalled=1" finds updates that are installed on the destination computer.
    $searchResult = $updateSearcher.Search("IsInstalled=0")
} catch {
    # failed to run search
}
# Try and get a collection of updates that match the search criteria.
$missingUpdates = $searchResult.Updates
# define timezone used by LastDeploymentChangeTime formatting
$timezone = [System.TimeZoneInfo]::FindSystemTimeZoneById((Get-WmiObject -Class Win32_TimeZone).StandardName)
# define empty missing update collection
$missingUpdateCollection = @()
# loop through all missing updates and format a pretty object with desired update details
if ($missingUpdates.count -gt 0) {
    $missingUpdates | ForEach-Object {
        $updateObject = $null
        $updateObject = [PSCustomObject]@{
            KBArticleIDs             = @($_.KBArticleIDs | ForEach-Object {$_})
            LastDeploymentChangeTime = "$([System.TimeZoneInfo]::ConvertTimeFromUtc($_.LastDeploymentChangeTime, $timezone))"
            Size                     = "$([Math]::round($_.maxdownloadsize / 1MB,0))MB"
            MsrcSeverity             = $_.MsrcSeverity
            Title                    = $_.Title
            RevisionNumber           = $_.Identity.RevisionNumber
        }
        $missingUpdateCollection += $updateObject
    }
}

# define empty installed update collection
$installedUpdateCollection = @()
# A collection of installed updates
$installedUpdates = Get-HotFix
# loop through all installed updates and format a pretty object with desired update details
if ($installedUpdates.count -gt 0) {
    $installedUpdates | ForEach-Object {
        $updateObject = $null
        $updateObject = [PSCustomObject]@{
            Description = $_.Description
            HotFixID    = @($_.HotFixID | ForEach-Object {$_})
            InstalledBy = "$($_.InstalledBy)"
            InstalledOn = "$($_.InstalledOn)"
        }
        $installedUpdateCollection += $updateObject
    }
}
$dateOfLastUpdateInstall = ($installedUpdates | Sort-Object -Property InstalledOn)[-1].InstalledOn
$updatesLastInstalled = @($installedUpdates | Where-Object{$_.InstalledOn -eq $dateOfLastUpdateInstall} | ForEach-Object{$_.HotFixID})

# build an object with all the update info
$update_meta = [PSCustomObject]@{
    missing_update_count        = $missingUpdateCollection.count
    missing_updates             = $missingUpdateCollection
    installed_update_count      = $installedUpdateCollection.count
    installed_updates           = $installedUpdateCollection
    date_of_last_update_install = "$dateOfLastUpdateInstall"
    report_date                 = "$(Get-Date)"
    updates_last_installed      = $updatesLastInstalled
    last_boot_time              = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime.ToString("G")
}

$update_meta | ConvertTo-Json

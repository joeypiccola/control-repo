# a collection of installed updates
$installedUpdates = Get-HotFix
# get and format some useful installed update data
$dateOfLastUpdateInstall = ($installedUpdates | Sort-Object -Property InstalledOn)[-1].InstalledOn
$updatesLastInstalled    = @($installedUpdates | Where-Object {$_.InstalledOn -eq $dateOfLastUpdateInstall} | ForEach-Object {$_.HotFixID})
# get and format some useful system data
$last_boot_time = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime.ToString("G")
# make it pretty
$update_meta = [PSCustomObject]@{
    installed_update_count = $installedUpdates.count
    last_update_install    = "$dateOfLastUpdateInstall" # string needed for proper json
    updates_last_installed = $updatesLastInstalled
    last_boot_time         = $last_boot_time
}
# write out json
$update_meta | ConvertTo-Json

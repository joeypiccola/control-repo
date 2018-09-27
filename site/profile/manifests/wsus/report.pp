# == Class: profile::wsus::report
class profile::wsus::report (
) {

  require profile::wsus::client
  require profile::wsus::pswindowsupdate

  schedule { 'nightly':
    period => daily,
    range  => '18:00 - 23:00',
    repeat => 1,
  }

  exec { 'get_windowsupdate':
    provider => 'powershell',
    schedule => 'nightly',
    command  => '$missingUpdates = Get-WindowsUpdate
                 $updateCollection = @()
                 $missingUpdates | %{
                     $updateObject = $null
                     $updateObject = [pscustomobject]@{
                         KB = "KB" + $_.KBArticleIDs
                         LastDeploymentChangeTime = $_.LastDeploymentChangeTime.tostring("MM-dd-yyyy hh:mm:ss tt")
                         Size = "$([math]::round($_.maxdownloadsize / 1MB,0))MB"
                         MsrcSeverity = $_.MsrcSeverity
                         Title = $_.Title
                     }
                     $updateCollection += $updateObject
                 }
                 $kbarray = @()
                 $updateCollection | %{$kbarray += $_.kb}
                 # get installed updates
                 $installedkbarray = @()
                 $getinstalledUpdates = Get-HotFix
                 $getinstalledUpdates | %{$installedkbarray += $_.hotfixid}
                 # build an object with all the update info
                 $windowsupdatereporting_col = @()
                 $update_meta = [pscustomobject]@{
                     missing_update_count = $updateCollection.Count
                     missing_update_detail = $updateCollection
                     missing_update_kbs = $kbarray
                     installed_update_count = $getinstalledUpdates.count
                     installed_update_kbs = $installedkbarray
                 }
                 $scan_meta = [pscustomobject]@{
                     last_run_time = (Get-Date -Format "MM-dd-yyyy hh:mm:ss tt")
                 }
                 $meta = [pscustomobject]@{
                     scan_meta = $scan_meta
                     update_meta = $update_meta
                 }
                 $fact_name = [pscustomobject]@{
                     wsus_scan = $meta
                 }
                 $windowsupdatereporting_col += $fact_name
                 if (!($DoNotGeneratePuppetFact)) {
                     Write-Verbose "Creating updatereporting.json Puppet fact."
                     $factContent = $windowsupdatereporting_col | ConvertTo-Json -Depth 4
                     $factPath = "C:/ProgramData/PuppetLabs/facter/facts.d/wsus_scan.json"
                     # force UTF8 with no BOM to make facter happy (Out-File -Encoding UTF8 does not work, Add-Content does not work, >> does not work)
                     $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
                     [System.IO.File]::WriteAllLines($factPath, $factContent, $Utf8NoBomEncoding)
                 } else {
                     Write-Output $windowsupdatereporting_col
                 }',
  }

}

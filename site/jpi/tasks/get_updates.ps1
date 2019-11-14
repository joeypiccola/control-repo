$patchFile = 'C:\patch.txt'
$patchData = @{
    count = [int](Get-Content -Path $patchFile)
} | ConvertTo-Json
Write-Output $patchData
$patchFile = 'C:\patch.txt'
[int]$patchFileContents = Get-Content -Path $patchFile
$lessOnePatch = $patchFileContents - 1
Remove-Item $patchFile
Add-Content -Path $patchFile -Value $lessOnePatch
Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 20)
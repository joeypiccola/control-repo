$patchFile = 'C:\patch.txt'
Remove-Item $patchFile -ErrorAction SilentlyContinue
Add-Content -Path $patchFile -Value (Get-Random -Minimum 1 -Maximum 3)

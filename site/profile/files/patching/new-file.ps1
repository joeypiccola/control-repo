$oi = Get-Random -Minimum 1000000 -Maximum 9999999
New-Item -Path c:\deploy -ItemType File -Name "$oi`_file.txt" -Force
start-sleep -Seconds 100
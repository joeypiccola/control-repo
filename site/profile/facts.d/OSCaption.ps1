$captionQuery = (Get-WmiObject -class Win32_OperatingSystem).Caption
Write-Output "oscaption=$captionQuery"
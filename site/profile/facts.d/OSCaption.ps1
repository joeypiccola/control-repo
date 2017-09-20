$captionQuery = (Get-WmiObject -class Win32_OperatingSystem -Property Caption).Caption
Write-Output "oscaption=$captionQuery"
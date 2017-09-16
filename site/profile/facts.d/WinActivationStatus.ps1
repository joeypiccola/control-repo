switch ((Get-WmiObject -Class SoftwareLicensingProduct | Where-Object {$_.ApplicationID -eq "55c92734-d682-4d71-983e-d6ec3f16059f" -AND $_.PartialProductKey -ne $null}).LicenseStatus ) {
    '0' {
        Write-Output 'WinActivationStatus=Unactivated'
    }
    '1' {
        Write-Output 'WinActivationStatus=Activated'
    }
    '2' {
        Write-Output 'WinActivationStatus=OOBGrace'
    }
    '3' {
        Write-Output 'WinActivationStatus=OOTGrace'
    }
    '4' {
        Write-Output 'WinActivationStatus=NonGenuineGrace'
    }
    '5' {
        Write-Output 'WinActivationStatus=Notification'
    }
    '6' {
        Write-Output 'WinActivationStatus=ExtendedGrace'
    }
}
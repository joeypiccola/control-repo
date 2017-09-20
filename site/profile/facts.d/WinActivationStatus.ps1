switch ((Get-WmiObject -Class SoftwareLicensingProduct -Filter "ApplicationID='55c92734-d682-4d71-983e-d6ec3f16059f' AND PartialProductKey IS NOT NULL" -Property LicenseStatus).LicenseStatus ) {
    '0' {
        Write-Output 'winactivationstatus=Unactivated'
    }
    '1' {
        Write-Output 'winactivationstatus=Activated'
    }
    '2' {
        Write-Output 'winactivationstatus=OOBGrace'
    }
    '3' {
        Write-Output 'winactivationstatus=OOTGrace'
    }
    '4' {
        Write-Output 'winactivationstatus=NonGenuineGrace'
    }
    '5' {
        Write-Output 'winactivationstatus=Notification'
    }
    '6' {
        Write-Output 'winactivationstatus=ExtendedGrace'
    }
}
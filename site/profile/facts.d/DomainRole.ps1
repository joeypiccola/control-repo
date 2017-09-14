switch ((Get-WmiObject -Class Win32_ComputerSystem).DomainRole)
{
    '0' {
        Write-Output 'Standalone Workstation'
    }
    '1' {
        Write-Output 'Member Workstation'
    }
    '2' {
        Write-Output 'Standalone Server'
    }
    '3' {
        Write-Output 'Member Server'
    }
    '4' {
        Write-Output 'Backup Domain Controller'
    }
    '5' {
        Write-Output 'Primary Domain Controller'
    }
}
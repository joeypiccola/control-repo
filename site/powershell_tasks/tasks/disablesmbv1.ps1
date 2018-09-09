Param (
    [Parameter(Mandatory=$True)]
    [ValidateSet('get', 'set')]
    [string]$action
)

$ErrorActionPreference = 'Stop'

switch ($action) {
    'get' {
        switch -Regex ((Get-WmiObject -Class win32_operatingsystem).version) {
            '6.1' {
                if ($key = Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\' -name 'smb1' -ErrorAction SilentlyContinue) {
                    if ($key.smb1 -eq 1) {
                        $Enable_SMB1Protocol = $true
                    } else {
                        $Enable_SMB1Protocol = $false
                    }
                } else {
                    $Enable_SMB1Protocol = $true
                }
                $test = [PSCustomObject]@{
                    Enable_SMB1Protocol    = $Enable_SMB1Protocol
                    Installed_SMB1Protocol = 'n/a'
                }
            }
            Default {
                $test = [PSCustomObject]@{
                    Enable_SMB1Protocol    = (Get-SmbServerConfiguration).EnableSMB1Protocol
                    Installed_SMB1Protocol = (Get-WindowsFeature -Name fs-smb1).Installed
                }
            }
        }
        Write-Output ($test | ConvertTo-Json)
    }
    'set' {
        try {
            switch -Regex ((Get-WmiObject -Class win32_operatingsystem).version) {
                '6.1' {
                    # does the key  exist?
                    $key = Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\' -name 'smb1' -ErrorAction SilentlyContinue

                }
                Default {
                    # if smb1 is enabled then disable it
                    if (Get-SmbServerConfiguration | Select-Object EnableSMB1Protocol) {
                        Set-SmbServerConfiguration -EnableSMB1Protocol $false -Confirm:$false
                    }
                    # remove feature for good measure
                    Remove-WindowsFeature -Name fs-smb1 -Confirm:$false
                }
            }
        } catch {
            Write-Error $_.Exception.Message
        }
    }
}
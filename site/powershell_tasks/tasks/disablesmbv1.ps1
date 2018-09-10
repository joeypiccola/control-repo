[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "", Justification="bug")]

Param (
    [Parameter(Mandatory=$True)]
    [ValidateSet('get', 'set')]
    [string]$action,
    [switch]$reboot = $false,
    [switch]$forcereboot = $false
)

$ErrorActionPreference = 'Stop'
$change = $false

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
                    Installed_SMB1Protocol = (Get-WindowsFeature -Name 'fs-smb1').Installed
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

                    if ($key) {
                        # yes. if smb1 is enabled then disable it
                        if ($key.smb1 -eq 1) {
                            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" SMB1 -Type DWORD -Value 0 -Force
                            $change = $true
                        }
                    } else {
                        # no. the key does not exist, assume smb1 is enabled and disable it
                        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\parameters" SMB1 -Type DWORD -Value 0 -Force
                        $change = $true
                    }
                }
                Default {
                    # if smb1 is enabled then disable it
                    if (Get-SmbServerConfiguration | Select-Object EnableSMB1Protocol) {
                        Set-SmbServerConfiguration -EnableSMB1Protocol $false -Confirm:$false
                        if ((Get-WindowsFeature -Name 'fs-smb1').Installed) {
                            # remove feature for good measure
                            Uninstall-WindowsFeature -Name 'fs-smb1' -Confirm:$false
                        }
                        $change = $true
                    }
                }
            }
            # if reboot requested then Q a reboot
            if ($reboot) {
                # do we want to reboot even on systems that received no change?
                if ($change -or $forcereboot) {
                    shutdown /s /t 10 /f /d p:4:1 /c "Puppet Task Reboot | Disable SMBv1"
                }
            }
        } catch {
            Write-Error $_.Exception.Message
        }
    }
}
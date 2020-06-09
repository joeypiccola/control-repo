function Get-SQLInstanceInfo {
    [CmdletBinding()]
    Param (
        [Parameter()]
        [switch]$test,
        [Parameter(Mandatory=$true)]
        [string]$instance_name
    )
    # get all installed sql instances
    $instances = Get-ItemProperty -Path 'HKLM:\\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL'
    if ($instances.$instance_name) {
        if ($test) { Write-Output $true; return }
        $instance_name_full = $instances.$instance_name
        $instance_setup_key = "HKLM:\\SOFTWARE\Microsoft\Microsoft SQL Server\$instance_name_full\Setup"
        $instance_info = Get-ItemProperty -Path $instance_setup_key
        $instance_info | Add-Member -NotePropertyName 'InstanceName' -NotePropertyValue $instance_name
        $instance_info | Add-Member -NotePropertyName 'BuildNumber' -NotePropertyValue $instance_info.PatchLevel
        $instance_info.PatchLevel = (Convert-SQLPatchLevel -patchLevel $instance_info.PatchLevel)
        $instance_info.Version = (Convert-SQLVersion -version $instance_info.Version)
        Write-Output $instance_info
    } else {
        if ($test) { Write-Output $false; return }
        Write-Error "Provided instance of `"$instance_name`" not found."
    }
}

function Convert-SQLVersion {
    [CmdletBinding()]
    Param (
        $version
    )
    switch -wildcard ($version) {
        "14*" { Write-Output "SQL Server 2017" }
        "13*" { Write-Output "SQL Server 2016" }
        "12*" { Write-Output "SQL Server 2014" }
        "11*" { Write-Output "SQL Server 2012" }
        "10.5*" { Write-Output "SQL Server 2008 R2" }
        "10.4*" { Write-Output "SQL Server 2008" }
        "10.3*" { Write-Output "SQL Server 2008" }
        "10.2*" { Write-Output "SQL Server 2008" }
        "10.1*" { Write-Output "SQL Server 2008" }
        "10.0*" { Write-Output "SQL Server 2008" }
        "9*" { Write-Output "SQL Server 2005" }
        "8*" { Write-Output "SQL Server 2000" }
        default { Write-Output $version }
    }
}

function Convert-SQLPatchLevel {
    [CmdletBinding()]
    Param (
        $patchLevel
    )
    switch -wildcard ($patchLevel) {
        "13.0.5*" { Write-Output "SP 2" }
        "13.2.*" { Write-Output "SP 2" }
        "13.1.*" { Write-Output "SP 1" }
        "13.0.4*" { Write-Output "SP 1" }
        "13.0.2*" { Write-Output "RTM" }
        "13.0.1*" { Write-Output "RTM" }

        "12.0.6*" { Write-Output "SP 3" }
        "12.3.*" { Write-Output "SP 3" }
        "12.0.5*" { Write-Output "SP 2" }
        "12.2.*" { Write-Output "SP 2" }
        "12.0.4*" { Write-Output "SP 1" }
        "12.1.*" { Write-Output "SP 1" }
        "12.0.2*" { Write-Output "RTM" }

        "11.0.7*" { Write-Output "SP 4" }
        "11.4.*" { Write-Output "SP 4" }
        "11.0.6*" { Write-Output "SP 3" }
        "11.3.*" { Write-Output "SP 3" }
        "11.0.5*" { Write-Output "SP 2" }
        "11.2.*" { Write-Output "SP 2" }
        "11.0.3*" { Write-Output "SP 1" }
        "11.1.*" { Write-Output "SP 1" }
        "11.0.9*" { Write-Output "RTM" }
        "11.0.2*" { Write-Output "RTM" }

        "10.50.6*" { Write-Output "SP 3" }
        "10.53.*" { Write-Output "SP 3" }
        "10.50.4*" { Write-Output "SP 2" }
        "10.50.3*" { Write-Output "SP 2" }
        "10.52.*" { Write-Output "SP 2" }
        "10.50.2*" { Write-Output "SP 1" }
        "10.51.*" { Write-Output "SP 1" }
        "10.50.1*" { Write-Output "RTM" }

        "10.4.*" { Write-Output "SP 4" }
        "10.0.6*" { Write-Output "SP 4" }
        "10.0.5*" { Write-Output "SP 3" }
        "10.3.*" { Write-Output "SP 3" }
        "10.0.4*" { Write-Output "SP 2" }
        "10.0.3*" { Write-Output "SP 2" }
        "10.2.*" { Write-Output "SP 2" }
        "10.0.2*" { Write-Output "SP 1" }
        "10.1.*" { Write-Output "SP 1" }
        "10.0.1*" { Write-Output "RTM" }

        "9.4.*" { Write-Output "SP 4" }
        "9.0.5*" { Write-Output "SP 4" }
        "9.3.*" { Write-Output "SP 3" }
        "9.0.4*" { Write-Output "SP 3" }
        "9.0.3*" { Write-Output "SP 2" }
        "9.2.*" { Write-Output "SP 2" }
        "9.0.2*" { Write-Output "SP 1" }
        "9.1.*" { Write-Output "SP 1" }
        "9.0.1*" { Write-Output "RTM" }
        default { Write-Output $patchLevel }
    }
}

# get all installed instances
$instances = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server').InstalledInstances
# define collection of instance data
$meta_instances = @()
foreach ($instance in $instances) {
    # try and get instance meta data
    try {
        $meta_instance = Get-SQLInstanceInfo -instance_name $instance | Select-Object -Property InstanceName, Version, PatchLevel, Edition, BuildNumber
        $meta_instances += $meta_instance
    } catch {
        # nothing to do here, just being lazy so we can contiune on with our loop
    }
}

Write-Output ($meta_instances | ConvertTo-Json)

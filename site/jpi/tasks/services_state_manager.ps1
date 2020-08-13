[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [string[]]$services,
    [Parameter(Mandatory = $false)]
    [ValidateSet('synchronous','asynchronous')]
    [string]$execution_behavior = 'synchronous',
    [Parameter(Mandatory = $false)]
    [ValidateSet('stop','continue')]
    [string]$error_action = 'stop',
    [Parameter(Mandatory = $false)]
    [bool]$validate_service_names = $true,
    [Parameter(Mandatory = $true)]
    [ValidateSet('start','stop','restart')]
    [string]$action
)

# define pref vars
$ErrorActionPreference = 'Stop'
$WarningPreference     = 'Continue'
$VerbosePreference     = 'SilentlyContinue'

if ($services -match '\*') {
    Write-Error "Asterisk deteced in service names." -ErrorAction Stop
}

# format our service csv data
#TODO: maybe find way to remove element in array that is a sinle or multiple set of spaces
$services = $services.split(',',[System.StringSplitOptions]::RemoveEmptyEntries).Trim()

if ($validate_service_names) {
    # set an initial service validation count
    $invalidServiceNameCount = 0
    # loop over services to validate them
    foreach ($service in $services) {
        try {
            Get-Service -Name $service -ErrorAction Stop | Out-Null
        } catch {
            Write-Verbose "Service not found: `"$service`"." -Verbose
            $invalidServiceNameCount++
        }
    }
    # if we found invalid service names error and stop
    if ($invalidServiceNameCount -gt 0) {
        Write-Error "Invalid service names detected." -ErrorAction Stop
    }
}

switch ($execution_behavior) {
    'synchronous' {
        foreach ($service in $services) {
            try {
                Write-Verbose "Trying to $action`: `"$service`"." -Verbose
                switch ($action) {
                    'start' {
                        Start-Service -name $service -ErrorAction $error_action
                    }
                    'stop' {
                        Stop-Service -name $service -ErrorAction $error_action
                    }
                    'restart' {
                        Restart-Service -name $service -ErrorAction $error_action
                    }
                }
                $gService = Get-Service -Name $service
                Write-Verbose "Successful $action`: `"$service`" (Status = $($gService.status))." -Verbose
            } catch {
                Write-Verbose "Failed to $action service: `"$service`"." -Verbose
                Write-Error "Failed to $action service: `"$service`"." -ErrorAction $error_action
            }
        }
    }
    'asynchronous' {
        #TODO: finish this if useful
    }
}

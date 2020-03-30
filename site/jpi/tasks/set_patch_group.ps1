Param (
    [Parameter(Mandatory = $True)]
    [ValidateSet('get', 'set', 'delete')]
    [string]$action,
    [Parameter()]
    [string]$fact_value
)

Write-Verbose 'this is a verbose test'

# define pref vars
$ErrorActionPreference = 'Stop'
$WarningPreference     = 'Continue'
$VerbosePreference     = 'Continue'

if ($action -eq 'set' -and [string]::IsNullOrEmpty($fact_value)) {
    Write-Error "Action of set was defined but no fact_value was provided."
}

$fact_file_path = "C:\ProgramData\PuppetLabs\facter\facts.d\patch_group.txt"
$fact_file_existence = Test-Path -Path $fact_file_path

switch ($action) {
    'get' {
        # get the value of the provided fact.
        if ($fact_file_existence) {
            $fact_value = (Get-Content -Path $fact_file_path).Split('=')[1]
            Write-Output $fact_value
        } else {
            Write-Verbose "$fact_file_path not found to get."
        }
    }
    'set' {
        # set the provided fact. if it does not exist create it
        if ($fact_file_existence) {
            Remove-Item -Path $fact_file_path -Force
        }
        New-Item -ItemType File -Path $fact_file_path -Value "patch_group=$fact_value" | out-null
    }
    'delete' {
        # delete the provided fact.
        if ($fact_file_existence) {
            Remove-Item -Path $fact_file_path -Force
        } else {
            Write-Verbose "$fact_file_path not found to delete."
        }
    }
}




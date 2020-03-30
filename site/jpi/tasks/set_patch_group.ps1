Param (
    [Parameter(Mandatory = $True)]
    [ValidateSet('get', 'set', 'delete')]
    [string]$action,
    [Parameter()]
    [string]$patch_group
)

Write-Verbose 'this is a verbose test'

# define pref vars
$ErrorActionPreference = 'Stop'
$WarningPreference     = 'Continue'
$VerbosePreference     = 'Continue'

if ($action -eq 'set' -and [string]::IsNullOrEmpty($patch_group)) {
    Write-Error "Action of $action was defined but no patch_group was provided."
}

$fact_file_path = "C:\ProgramData\PuppetLabs\facter\facts.d\patch_group.txt"
$fact_file_existence = Test-Path -Path $fact_file_path

switch ($action) {
    'get' {
        # get the value of the provided fact.
        if ($fact_file_existence) {
            $patch_group = (Get-Content -Path $fact_file_path).Split('=')[1]
            Write-Output $patch_group
        } else {
            Write-Verbose "$fact_file_path not found to get."
        }
    }
    'set' {
        # set the provided fact. if it does not exist create it
        if ($fact_file_existence) {
            Remove-Item -Path $fact_file_path -Force
        }
        New-Item -ItemType File -Path $fact_file_path -Value "patch_group=$patch_group" | out-null
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




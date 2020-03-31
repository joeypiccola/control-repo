[CmdletBinding()]
Param (
    [Parameter(Mandatory = $True)]
    [ValidateSet('get', 'set', 'delete')]
    [string]$action,
    [Parameter()]
    [string]$patch_group
)

# define pref vars
$ErrorActionPreference = 'Stop'
$WarningPreference     = 'Continue'
#$VerbosePreference     = 'Continue'


if ($action -eq 'set' -and [string]::IsNullOrEmpty($patch_group)) {
    Write-Error "Action of $action was defined but no patch_group was provided."
}

$fact_file_path = "C:\ProgramData\PuppetLabs\facter\facts.d\patch_group.txt"
$fact_file_existence = Test-Path -Path $fact_file_path

Write-Verbose "Running with action: $action."
Write-Verbose "patch_group fact path: $fact_file_path."
Write-Verbose "path_group fact existance: $fact_file_existence."

function Get-PatchGroupFact {
    # get the value of the patch group fact
    if ($fact_file_existence) {
        $patch_group = (Get-Content -Path $fact_file_path).Split('=')[1]
        Write-Verbose "patch_group fact value: $patch_group."
        if ($action -eq 'get') {
            Write-Output $patch_group
        }
    }
}

Get-PatchGroupFact

switch ($action) {
    'get' {
        # do nothing because technically we already wrote it out in verbose
    }
    'set' {
        if ($fact_file_existence) {
            Write-Verbose "Removing $fact_file_path."
            Remove-Item -Path $fact_file_path -Force
        }
        $fact_contents = "patch_group=$patch_group"
        Write-Verbose "Creating $fact_file_path with `"$fact_contents`"."
        New-Item -ItemType File -Path $fact_file_path -Value $fact_contents | Out-Null
    }
    'delete' {
        if ($fact_file_existence) {
            Write-Verbose "Removing $fact_file_path."
            Remove-Item -Path $fact_file_path -Force
        }
    }
}

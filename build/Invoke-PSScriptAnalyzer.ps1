[CmdletBinding()]
Param(
    [Parameter()]
    [ValidateSet('CodeFormattingOTBS', 'default')]
    [string]$test = ''
)

$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'
$psModule = 'PSScriptAnalyzer'

if (Get-Module $psModule -ListAvailable) {
    Import-Module -Name $psModule
    switch ($test) {
        'CodeFormattingOTBS' {
            $results = Invoke-ScriptAnalyzer -Path $pwd -Recurse -Settings CodeFormattingOTBS
        }
        'default' {
            $results = Invoke-ScriptAnalyzer -Path $pwd -Recurse
        }
    }

    Write-Information "BEGIN $test results"
    $results
    Write-Information "END $test results"

    if ($results.count -gt 0) {
        exit 1
    }
} else {
    Write-Error "$psModule not installed on system"
}
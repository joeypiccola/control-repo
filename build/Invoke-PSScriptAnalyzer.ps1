[CmdletBinding()]
Param(
    [Parameter()]
    [ValidateSet('CodeFormattingOTBS', 'default')]
    [string]$test = ''
)

$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'

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
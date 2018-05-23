$InformationPreference = 'continue'
$ErrorActionPreference = 'stop'

$LintResults = @()
foreach ($pp in (Get-ChildItem -path .\ -Recurse -Include *.pp)){
    $LintResult = & puppet-lint $pp --with-filename --no-140chars-check
    $LintResults += $LintResult
    Write-Information $LintResults
}
if ($LintResults | Select-String -Pattern 'error') {exit 1}
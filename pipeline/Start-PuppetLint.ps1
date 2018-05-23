$InformationPreference = 'continue'
$ErrorActionPreference = 'stop'

$LintResults = @()
foreach ($pp in (Get-ChildItem -path .\ -Recurse -Include *.pp)){
    Write-Information "Linting $($pp.FullName)"
    $LintResult = & puppet-lint $pp.FullName --with-filename --no-140chars-check
    $LintResults += $LintResult
}

$LintResults | %{Write-Information $_}
if ($LintResults | Select-String -Pattern 'error') {exit 1}
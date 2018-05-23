$InformationPreference = 'continue'
$ErrorActionPreference = 'stop'

foreach ($pp in (Get-ChildItem -path .\ -Recurse -Include *.pp)) {
    & puppet parser validate $pp --environment production
    if ($LASTEXITCODE -ne 0) {exit 1}
}
Write-Information 'No parsing errors found'
$InformationPreference = 'Continue'
$ErrorActionPreference = 'Continue'
$fail = $false

foreach ($pp in (Get-ChildItem -path .\ -Recurse -Include *.pp)) {
    Write-Information "Parsing $($pp.FullName)"
    # & puppet parser validate $pp.FullName --environment production
    if ($LASTEXITCODE -ne 0) {$fail = $true}
}
switch ($fail) {
    $true {
        Write-Information 'Parsing errors found'
        exit 1
    }
    $false {
        Write-Information 'No parsing errors found'
    }
}
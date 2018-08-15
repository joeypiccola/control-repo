$InformationPreference = 'Continue'
$ErrorActionPreference = 'Stop'
$fail = $false

Import-Module 'powershell-yaml'

$yamlFiles = Get-ChildItem -Path $pwd -Include "*.yaml" -Recurse

foreach ($yamlFile in $yamlFiles) {
    Write-Information "Parsing $($yamlFile.FullName)"
    $fileContent = $null
    [string[]]$fileContent = Get-Content $yamlFile.FullName
    $content = ''
    foreach ($line in $fileContent) {
        $content = $content + "`n" + $line
    }

    try {
        $yaml = ConvertFrom-YAML $content
        $yaml
    } catch {
        Write-Information "Failed to parse $($yamlFile.FullName)"
        $fail = $true
    }
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
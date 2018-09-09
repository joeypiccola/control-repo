$InformationPreference = 'Continue'
$ErrorActionPreference = 'Stop'

$files = @()

$ps1Files = Get-ChildItem -path $pwd -Recurse -Include "*.ps1" --Exclude 'disablesmbv1.ps1'

foreach ($ps1File in $ps1Files) {
    Write-Information "Parsing $($ps1File.FullName)"
    $contents = Get-Content -Path $ps1File
    if ($null -eq $contents) {
        continue
    }
    $errors = $null
    $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
    $file = $null
    # ugh, this got weird. PathToThePs1Filez is to suppress bug in PSUseConsistentWhitespace rul
    $file = [PSCustomObject]@{
        PathToThePs1Filez = $ps1File
        SyntaxErrorsFound = ($errors.Count -gt 0)
    }
    $files += $file
}

if ($files | Where-Object {$_.syntaxerrorsfound -eq $true}) {
    exit 1
}
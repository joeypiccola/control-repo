$InformationPreference = 'continue'
$ErrorActionPreference = 'stop'

$files = @()
foreach ($ps1 in (Get-ChildItem -path .\ -Recurse -Include *.ps1)) {
    Write-Information "Parsing $($ps1.FullName)"
    $contents = Get-Content -Path $ps1
    if ($null -eq $contents) {
        continue
    }
    $errors = $null
    $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
    $file = $null
    $file = New-Object psobject -Property @{
        Path = $ps1
        SyntaxErrorsFound = ($errors.Count -gt 0)
    }
    $files += $file
}

if ($files |?{$_.syntaxerrorsfound -eq $true}) {exit 1}
$InformationPreference = 'continue'
$ErrorActionPreference = 'stop'

$files = @()
foreach ($ps1 in (Get-ChildItem -path .\ -Recurse -Include *.ps1)) {
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
$files | %{Write-Information $_.path}
if ($files |?{$_.syntaxerrorsfound -eq $true}) {exit 1}
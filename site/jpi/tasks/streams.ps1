$VerbosePreference     = 'Continue'
$InformationPreference = 'Continue'

Write-Verbose "this is verbose"
Write-Host "this is host"
Write-Information "this is information"

@{key='value'} | ConvertTo-Json

[CmdletBinding()]
Param(
    [Parameter()]
    [ValidateSet('puppet', 'ruby')]
    [string]$test = ''
)

$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'
$psModule = 'PuppetDevelopmentdKit'

if (Get-Module $psModule -ListAvailable) {
    Import-Module -Name $psModule
    pdk validate $test
} else {
    Write-Error "$psModule not installed on system"
}
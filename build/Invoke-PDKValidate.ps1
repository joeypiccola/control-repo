[CmdletBinding()]
Param(
    [Parameter()]
    [ValidateSet('puppet', 'ruby')]
    [string]$test = ''
)

$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'

Import-Module -Name 'PuppetDevelopmentKit'
pdk validate $test
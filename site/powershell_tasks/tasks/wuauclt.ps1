[CmdletBinding()]
Param (
    [Parameter()]
    ValidateSet('detectnow','reportnow')]
    [string]$job
)

wuauclt /$job
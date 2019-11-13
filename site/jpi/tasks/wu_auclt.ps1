Param (
    [Parameter(Mandatory = $True)]
    [ValidateSet('detectnow', 'reportnow', 'resetauthorization /detectnow')]
    [string]$job
)

wuauclt /$job

Param (
    [Parameter(Mandatory=$True)]
    [ValidateSet('detectnow', 'reportnow')]
    [string]$job
)

wuauclt /$job
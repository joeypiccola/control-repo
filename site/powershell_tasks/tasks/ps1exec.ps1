Param(
    [Parameter(Mandatory = $True)]
    [string]$Command
)

Invoke-Expression $Command
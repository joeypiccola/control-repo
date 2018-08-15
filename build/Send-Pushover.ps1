[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "", Justification="just can't fix this")]

[CmdletBinding()]
Param(
    [Parameter()]
    [string]$user,
    [string]$token,
    [ValidateSet('succeeded', 'failed', 'aborted')]
    [string]$status,
    [string]$build_id,
    [string]$branch
)

$parameters = @{
    token   = $token
    user    = $user
    message = "Build #$build_id - $branch $status"
    title   = "Puppet Code Deploy CI"
}

$parameters | Invoke-RestMethod -Method Post -Uri "https://api.pushover.net/1/messages.json"
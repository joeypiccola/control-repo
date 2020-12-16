[CmdletBinding()]
Param (
    [Parameter()]
    [String]$message
)

@{the_message_is = $message} | ConvertTo-Json

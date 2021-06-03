[CmdletBinding()]
Param(
    [Parameter()]
    [string]$file_contents = 'default_content',
    [Parameter(Mandatory)]
    [string]$file_name
)

New-Item -ItemType File -Path "C:\$file_name.txt" -Value $file_contents -force

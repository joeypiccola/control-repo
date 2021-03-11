[CmdletBinding()]
Param(
    [Parameter(Mandatory)]
    [string]$file_contents
)

New-Item -ItemType File -Path 'C:\myFile.txt' -Value $file_contents

[CmdletBinding()]
Param(
    [Parameter(Mandatory)]
    [integer]$file_contents
)

New-Item -ItemType File -Path 'C:\myFile.txt' -Value $file_contents

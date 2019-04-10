Param (
    [Parameter(Mandatory = $True)]
    [ValidateSet('get', 'set', 'delete')]
    [string]$action,
    [Parameter()]
    [string]$fact_name,
    [Parameter()]
    [string]$fact_value
)

$fact_path = "C:\ProgramData\PuppetLabs\facter\facts.d"
$fact_file_name = $fact_name + '.txt'
$fact_file_path = Join-Path -Path $fact_path -ChildPath $fact_file_name
$fact_file_existence = Test-Path -Path $fact_file_path

switch ($action) {
    'get' {
        # get the value of the provided fact.
        if ($fact_file_existence) {
            $fact_value = (Get-Content -Path $fact_file_path).Split('=')[1]
        }
        Write-Output $fact_value
    }
    'set' {
        # set the provided fact. if it does not exist create it
        if ($fact_file_existence) {
            Remove-Item -Path $fact_file_path -Force
        }
        New-Item -ItemType File -Path $fact_file_path -Value "$fact_name=$fact_value"
    }
    'delete' {
        # delete the provided fact.
        if ($fact_file_existence) {
            Remove-Item -Path $fact_file_path -Force
        }
    }
}
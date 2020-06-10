# .\Invoke-InstancePatch.ps1 -binary_url 'https://artifactory.davita.com/artifactory/win-binaries/sql/2014/sqlserver2014sp3-kb4022619-x64-enu.exe' -instance_name 'MSSQLSERVER' -destination_directory_path 'D:\SQLInstall' -delete_binary_after_install

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)]
    [uri]$binary_url,
    [Parameter(Mandatory=$true)]
    [string]$instance_name,
    [Parameter()]
    [ValidateSet('sql','rs','olap')]
    [string]$component = 'sql',
    [Parameter(Mandatory=$true)]
    [string]$destination_directory_path,
    [Parameter()]
    [switch]$force_download = $false,
    [Parameter()]
    [switch]$delete_binary_after_install = $false
)

# deifine pref vars
$VerbosePreference = "SilentlyContinue"
$ErrorActionPreference = "Stop"

# define some helper functions
function Get-SQLInstanceInfo {
    [CmdletBinding()]
    Param (
        [Parameter()]
        [switch]$test,
        [Parameter(Mandatory=$true)]
        [string]$instance_name,
        [Parameter()]
        [ValidateSet('sql','rs','olap')]
        [string]$component = 'sql'
    )
    # get all installed sql instances for the provided component. SilentlyContinue and let the following "if" deal with errors if component does not exist.
    $instances = Get-ItemProperty -Path "HKLM:\\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\$component" -ErrorAction SilentlyContinue
    if ($instances.$instance_name) {
        if ($test) { Write-Output $true; return }
        $instance_name_full = $instances.$instance_name
        $instance_setup_key = "HKLM:\\SOFTWARE\Microsoft\Microsoft SQL Server\$instance_name_full\Setup"
        $instance_info = Get-ItemProperty -Path $instance_setup_key
        Write-Output $instance_info
    } else {
        if ($test) { Write-Output $false; return }
        Write-Error "Provided instance of `"$instance_name`" not found for `"$component`" component."
    }
}

function Test-NetConnection2 {
    # Q: omg why are we doing this?
    # A: bc psv3 on anything older than 2012 does not have Test-NetConnection.
    Param (
        [Parameter()]
        [string]$ComputerName,
        [int]$Port
    )
    try {
        (New-Object Net.Sockets.TcpClient).Connect($ComputerName, $Port)
        Write-Output $true
    } catch {
        Write-Output $false
    }
}

# before we do anything, test to see if the provided instance is valid
# FIXME: this is redundant of the logic in Get-SQLInstanceInfo, plz fix
if (-not (Get-SQLInstanceInfo -instance_name $instance_name -test -component $component)) {
    Write-Error "Provided instance of `"$instance_name`" not found for `"$component`" component."
}

# define binary file name, path and destination directory path drive letter
$binary_file_name = $binary_url | Split-Path -Leaf
$binary_file_path = Join-Path -Path $destination_directory_path -ChildPath $binary_file_name
$destination_drive_letter = $binary_file_path | Split-Path -Qualifier

# test if destination directory, binary file and destination drive letter exist
$destination_directory_path_exist = Test-Path -Path $destination_directory_path
$binary_file_path_exist = Test-Path -Path $binary_file_path
$destination_drive_letter_exists = Test-Path -Path $destination_drive_letter

# if conditions are good then download the file
# FIXME: this is super ugly, plz fix
if ($force_download -or ($destination_directory_path_exist -and ($binary_file_path_exist -eq $false))) {
    # if force_download is $true and our destination_directory_path_exist is $false then lets make the directory
    if ($force_download -and ($destination_directory_path_exist -eq $false)) {
        # if destination_drive_letter_exists is $true then create the directory
        # FIXME: this check is not needed as Join-Path fails on a non-existent drive letter as part of $binary_file_path
        if ($destination_drive_letter_exists) {
            New-Item -ItemType Directory -Path $destination_directory_path -Force | Out-Null
        } else {
            Write-Error "Failed to download file. The drive letter `"$destination_drive_letter`" as specified in `"$binary_file_path`" does not exist."
        }
    }
    # if we can reach our binary url authority then try and download the file via BITS
    $binary_url_authority = ([System.Uri]$binary_url).Authority
    if (Test-NetConnection2 -Port 443 -ComputerName $binary_url_authority) {
        try {
            # set some timers and download the file
            $dl_start = Get-Date
            Start-BitsTransfer -Source $binary_url -Destination $binary_file_path
            $dl_stop = Get-Date
        } catch {
            Write-Error "Failed to download file via Start-BitsTransfer. Exception.Message: `"$($_.Exception.Message)`"."
        }
    }
    else {
        Write-Error "Failed to download $binary_file_name. $binary_url_authority is not reachable on tcp/443."
    }
} else {
    Write-Error "Failed to download $binary_file_name. (`$destination_directory_path_exist: $destination_directory_path_exist), (`$binary_file_path_exist = $binary_file_path_exist)."
}

# generate some pre-install data
$pre_patch_instance_info = Get-SQLInstanceInfo -instance_name $instance_name -component $component

# assume the file is blocked and unblock it
Unblock-File -Path $binary_file_path

# define install args for binary
$sp_args = @(
    "/instancename=$instance_name"
    "/IAcceptSQLServerLicenseTerms"
    "/action=Patch"
    "/quiet"
)

# set some timers and try to install the binary
try {
    $sp_start = Get-Date
    $sp = Start-Process -ArgumentList $sp_args -FilePath $binary_file_path -Wait -PassThru
    # if our exit code is not valid then error out
    # TODO: need to get list of all valid exit codes or detect success some other way
    $valid_exit_codes = @(0,3010)
    if ($valid_exit_codes -notcontains $sp.ExitCode) {
        Write-Error "Start-Process exited with a non-zero exit code: $($sp.ExitCode)"
    }
} catch {
    Write-Error "Failed to patch $instance_name from SP $($pre_patch_instance_info.PatchLevel) to desired version. Check C:\Program Files\Microsoft SQL Server\{version}\Setup Bootstrap\Log for details. Exception.Message: `"$($_.Exception.Message)`"."
} finally {
    $sp_stop = Get-Date
    # clean up
    if ($delete_binary_after_install) {
        # sleep for a bit to ensure nothing is accessing the binary
        Start-Sleep -Seconds 120
        Remove-Item -Path $binary_file_path
    }
}

# generate some post-install data
$post_patch_instance_info = Get-SQLInstanceInfo -instance_name $instance_name -component $component

# build an object with pre patch, post patch and meta patch data
$patch_instance_obj = [PSCustomObject]@{
    pre_patch  = [PSCustomObject]@{
        Version    = $pre_patch_instance_info.Version
        Edition    = $pre_patch_instance_info.Edition
        PatchLevel = $pre_patch_instance_info.PatchLevel
        SP         = $pre_patch_instance_info.SP
    }
    post_patch = [PSCustomObject]@{
        Version    = $post_patch_instance_info.Version
        Edition    = $post_patch_instance_info.Edition
        PatchLevel = $post_patch_instance_info.PatchLevel
        SP         = $post_patch_instance_info.SP
    }
    patch_meta = [PSCustomObject]@{
        instance_name     = $instance_name
        component         = $component
        install_duration  = "$(New-TimeSpan -Start $sp_start -End $sp_stop)"
        download_duration = "$(New-TimeSpan -Start $dl_start -End $dl_stop)"
        exit              = @{
            exit_code        = $sp.ExitCode
            valid_exit_codes = $valid_exit_codes
        }
    }
}

# write out our data
$patch_instance_obj | ConvertTo-Json -Depth 3

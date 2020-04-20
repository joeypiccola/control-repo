Param (
    [Parameter()]
    [switch]$reboot,
    [Parameter()]
    [bool]$mybool = $true
)

if ($reboot) {
    Write-Output "`$reboot value should be true and is `"$reboot`""
} else {
    Write-Output "`$reboot value should be false and is `"$reboot`""
}

if ($mybool) {
    Write-Output "`$mybool value should be true and is `"$mybool`""
} else {
    Write-Output "`$mybool value should be false and is `"$mybool`""
}

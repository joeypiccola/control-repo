Param (
    [Parameter()]
    [switch]$reboot
)

if ($reboot) {
    Write-Output "`$reboot value should be true and is `"$reboot`""
} else {
    Write-Output "`$reboot value should be false and is `"$reboot`""
}
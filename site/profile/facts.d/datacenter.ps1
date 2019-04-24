switch ($env:COMPUTERNAME.Substring(0,4).tolower()) {
    'sea1' {
        Write-Output "datacenter=sea1"
    }
    'den3' {
        Write-Output "datacenter=den3"
    }
    DEFAULT {
        Write-Output "datacenter=den3"
    }
}
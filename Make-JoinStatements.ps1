param (
    [string]$mainTable,
    [string[]]$joins
)

$sql = "SELECT`n`t*`nFROM`n`t$mainTable"

foreach ($join in $joins) {
    $sql += "`nFULL JOIN $join`n`tUSING($join" + "_id)"
}

Write-Output ($sql + ";")

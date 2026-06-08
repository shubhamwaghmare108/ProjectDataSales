# Database connection
$Database = "retail_oltp"
$User = "root"
$env:MYSQL_PWD = "S108108w"

# Output folder
$OutputFolder = "D:\ProjectDataSales\Dump"

New-Item -ItemType Directory -Force -Path $OutputFolder | Out-Null

# Get table list
$tables = mysql -u $User -D $Database -N -e "SHOW TABLES;"

foreach ($table in $tables) {

    Write-Host "Exporting $table..."

    $outfile = Join-Path $OutputFolder "$table.csv"

    mysql -u $User -D $Database `
        -e "SELECT * FROM $table" `
        --batch --raw `
        | ForEach-Object { $_ -replace "`t", "," } `
        | Out-File -Encoding UTF8 $outfile
}

Write-Host ""
Write-Host "Export completed!"
Write-Host "Files saved in $OutputFolder"
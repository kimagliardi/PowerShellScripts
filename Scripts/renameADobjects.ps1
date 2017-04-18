$csv = import-csv C:\scripts\cat.csv -Delimiter ";"

foreach($line in $csv){
    Get-ADUser $line.login | Rename-ADObject -NewName $line.newLogin
}
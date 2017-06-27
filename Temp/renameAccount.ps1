$csv = Import-Csv D:\PowerShellScripts\Temp\teste.csv -Delimiter ";"
foreach($line in $csv){
    Set-ADUser -Identity $line.name -Replace @{displayName=$line.name}
}
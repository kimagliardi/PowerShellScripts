$csv = import-csv C:\temp\updates.csv -Delimiter ","
$Groups = Get-PSWSUSGroup -Name 'computadores'


Import-Module PoshWSUS
Connect-PSWSUSServer -WsusServer <servername> -Port 8530

foreach($line in $csv){
    #Write-Host $line.update
    Get-PSWSUSUpdate -Update $line.update | Approve-PSWSUSUpdate -Group $Groups -Action Install 
}

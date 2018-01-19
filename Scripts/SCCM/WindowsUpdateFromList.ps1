$csv = import-csv C:\temp\updates_ariel.csv -Delimiter ","
$Groups = Get-PSWSUSGroup -Name 'computadores'


Import-Module PoshWSUS
Connect-PSWSUSServer -WsusServer med-wsus.colegiomedianeira.g12.br -Port 8530

foreach($line in $csv){
    #Write-Host $line.update
    Get-PSWSUSUpdate -Update $line.update | Approve-PSWSUSUpdate -Group $Groups -Action Install 
}
$csv = import-csv c:\Scripts

foreach($line in $csv){
   Enable-DistributionGroup -Identity $line.Name -Alias $line.mailNickName
}

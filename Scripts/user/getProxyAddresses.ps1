$csv = Import-CSV C:\temp\ajuste\o365lista.csv -Delimiter ';'

foreach($line in $csv){
   
   $Object = New-Object PSObject -Property @{
   proxyAddresses = Get-ADUser $line.UserPrincipalName -Properties * | select name,@{Name=’proxyaddresses’;E={$_.proxyaddresses -join ","}}} | Export-CSV C:\temp\ajuste\proxyLista.csv -NoTypeInformation -Append
  
  
  
   #Name = $line.UserPrincipalName } | Export-CSV C:\temp\ajuste\proxyLista.csv -NoTypeInformation -Append
}
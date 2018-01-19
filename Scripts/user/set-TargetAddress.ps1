$csv = Import-Csv C:\temp\targetAddress.csv


Foreach($line in $csv){
	Set-ADUser $line.samAccountName -Add @{targetaddress='SMTP:'+$line.samAccountName+'@asavbrm.onmicrosoft.com'}
}

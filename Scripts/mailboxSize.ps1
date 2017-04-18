#query all users
$(Foreach ($mailbox in Get-Mailbox -ResultSize unlimited -RecipientType UserMailbox){
$Stat = $mailbox | Get-MailboxStatistics | Select TotalItemSize,ItemCount
	New-Object PSObject -Property @{
	FirstName = $mailbox.FirstName
	LastName = $mailbox.LastName
	DisplayName = $mailbox.DisplayName
	TotalItemSize = $Stat.TotalItemSize
	ItemCount = $Stat.ItemCount
	PrimarySmtpAddress = $mailbox.PrimarySmtpAddress
	Alias = $mailbox.Alias
	}
}) | Select FirstName,LastName,DisplayName,TotalItemSize,ItemCount,PrimarySmtpAddress,Alias | 
Export-CSV C:\temp\MailboxReport.csv -NTI


####################################################################################################

#query para determinados usuários
$csv = Import-Csv  c:\temp\email.csv

Foreach($line in $csv){
   $name = Get-Mailbox -identity $line.Email  
   $stat = Get-MailboxStatistics -Identity $line.Email
   New-Object PSObject -Property @{
        alias = $name.alias
        TotalItemSize = $Stat.TotalItemSize
        ItemCount = $Stat.ItemCount
    } | Select-Object alias,TotalItemSize,ItemCount |
    Export-CSV -append c:\temp\MailboxReport.csv -NTI

}
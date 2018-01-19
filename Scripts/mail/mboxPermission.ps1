$csv = Import-csv C:\anchieta\sharedAnchieta.csv -Delimiter ";"
foreach($line in $csv){
    Add-MailboxPermission -Identity $line.Identity -AccessRights FullAccess -InheritanceType All -AutoMapping:$true -User $line.User
}
$csv = Import-Csv C:\anchieta\anchieta_licenc1.csv -Delimiter ";"

    foreach($line in $csv){
        write-host "Ajustando usuario: "  $line.UserPrincipalName
        Set-MailboxRegionalConfiguration $line.UserPrincipalName -TimeZone "E. South America Standard Time" -Language pt-br -DateFormat "dd/MM/yyyy" -TimeFormat "HH:mm"
        Set-MailboxRegionalConfiguration $line.UserPrincipalName -LocalizeDefaultFolderName
}

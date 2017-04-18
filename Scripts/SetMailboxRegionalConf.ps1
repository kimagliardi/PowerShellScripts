$csv = Import-Csv D:\office365\ajusteContas.csv

    foreach($line in $csv){
        Set-MailboxRegionalConfiguration $line.Name -TimeZone "E. South America Standard Time" –Language pt-BR -DateFormat "dd/MM/yyyy" -TimeFormat "HH:mm"
        Set-MailboxRegionalConfiguration $line.Name -LocalizeDefaultFolderName
    }
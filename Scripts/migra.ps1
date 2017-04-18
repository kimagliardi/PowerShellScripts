cd D:\Office365\
$password = Get-Content d:\Office365\cred.txt | ConvertTo-SecureString
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList admin@asavbrm.onmicrosoft.com,$password
$s = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $cred -Authentication Basic -AllowRedirection
$importresults = Import-PSSession $s




###################################################################################################
$csv = Import-csv i:\Temp\professores.csv -Delimiter ";"
#email
$users = "projetonuvem@asav.org.br" # List of users to email your report to (separate by comma)
$fromemail = "reportMigration@unisinos.br"
$server = "relay.unisinos.br" #enter your own SMTP server DNS name / IP address here

    $HTMLMiddle = ""
    $HTMLHeader = @"

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
    <h1>Office 365 - Relatorio de Migracao</h1>
    <head>
    <style>
    table, th, td {
        border:1px solid black;
        border-collapse: collapse;
        text-align: center;
    }
    .align-right {
    text-align: right;
}

    </head>
    </style>
    <body>
    <table style="width:100%"> 
        <tr>
            <th>Nome</th>
            <th>Usuario</th>
            <th>Copiado (MB)</th>
            <th>% de migracao</th>
        </tr>
"@

#while($true){   
    foreach ($line in $csv){
        $mailBoxSize = Get-Mailbox -Identity $line.Name| Get-MailboxStatistics |Select @{name="TotalItemSize (MB)"; expression={[math]::Round(($_.TotalItemSize.ToString().Split("(")[1].Split(" ")[0].Replace(",","")/1MB),2)}}
        $email = Get-mailbox -Identity $line.Name
        
        $displayName = $email.DisplayName
        $aliasName = $email.Alias
        $mailBoxSize= $mailBoxSize.'TotalItemSize (MB)'
        $percentual = [double]($mailBoxSize/$line.Size)*100
        $percentual = [math]::Round($percentual,2)


#Insere os dados do usuário na linha da planilha.

[string]$newFileName = [DateTime]::Now.ToString("HH:mm:ss") ;
$HTMLMiddle +=  @"
            <tr>
                <td>$displayName</td>       
                <td>$aliasName</td>
                <td>$mailBoxSize</td>
                <td>$percentual</td>
            </tr>

"@       
# Assemble the closing HTML for our report.
}
    $HTMLEnd = @"
    </table>
    <h2 class="align-right">$newFileName</h2>
    </div>
    </body>
    </html>
"@

# Assemble the final report from all our HTML sections
    $HTMLmessage = $HTMLHeader + $HTMLMiddle + $HTMLEnd
    $HTMLmessage | Out-File d:\lotes\"migracao.html";
    $HTMLMiddle = "" #limpa o log
        
# Email our report out
    send-mailmessage -from $fromemail -to $users -subject "Status Migracao O365" -BodyAsHTML -body $HTMLmessage -priority Normal -smtpServer $server
    #Start-Sleep -s 1800

    Remove-PSSession $s

#}
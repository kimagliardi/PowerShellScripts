    $csv = Import-csv d:\migracao.csv
    $HTMLMiddle = ""
    $HTMLHeader = @"

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
    <h1>Office 365 Migration Status Report</h1>
    <head>
    <style>
    table, th, td {
	    border:1px solid black;
	    border-collapse: collapse;
        text-align: center;
    }

    </head>
    </style>
    <body>
    <table style="width:100%"> 
	    <tr>
		    <th>Usuario</th>
		    <th>Email</th>
		    <th>Copiado (MB)</th>
		    <th>% Emails Migrados</th>
	    </tr>
"@

while($true){   
    foreach ($line in $csv){
        #Get-mailbox -Identity $line.Name | Get-mailboxStatistics | Select-Object displayname, totalitemsize
        $userName = Get-mailbox -Identity $line.Name | Select-Object displayname
        $size = Get-mailbox -Identity $line.Name | Get-mailboxStatistics | Select-Object totalitemsize
        #$per = ($line.Size/$size)*100
#Insere os dados do usuário na linha da planilha.
$HTMLMiddle +=  @"
            <tr>
                <td>$userName</td>       
                <td>$line.Name</td>
                <td>$size</td>
                <td>$per</td>
            </tr>

"@       
# Assemble the closing HTML for our report.
}
    $HTMLEnd = @"
    </table>
    </div>
    </body>
    </html>
"@

# Assemble the final report from all our HTML sections
    $HTMLmessage = $HTMLHeader + $HTMLMiddle + $HTMLEnd
# Save the report out to a file in the current path
#        [string]$newFileName = [DateTime]::Now.ToString("yyyyMMdd-HHmmss") + ".html"; ajustar e inserir no script novamente

    $HTMLmessage | Out-File d:\lotes\teste.html;
    Start-Sleep -s 1800
}


robocopy G:\ E:\ /E /Copy:DAT /IS /IT
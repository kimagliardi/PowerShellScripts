###Bloco que realiza o export da senha para um arquivo de texto
########################################################################################################
$username = "username"
$password = "password"
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$creds = New-Object System.Management.Automation.PSCredential -ArgumentList $username,$secureStringPwd
$secureStringText = $secureStringPwd | ConvertFrom-SecureString 
Set-Content "C:\ExportedPassword.txt" $secureStringText
########################################################################################################



###Bloco que realiza a leitura da senha, a partir de um arquivo de texto
########################################################################################################
$username = "domain\user"
$pwdTxt = Get-Content "C:\ExportedPassword.txt"
$securePwd = $pwdTxt | ConvertTo-SecureString 
$credObject = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $securePwd
########################################################################################################



###Bloco de script, propriamente dito..
########################################################################################################
$csv = Import-csv C:\scripts\computers.csv -Delimiter ";"


foreach($line in $csv){
    shutdown -s -f -t 1 -m \\$line.name
}
########################################################################################################
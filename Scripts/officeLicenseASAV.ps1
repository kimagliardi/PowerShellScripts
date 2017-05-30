param (
    [Parameter(Mandatory=$true)][string]$userfile
) #recebe o caminho do arquivo via shell

$csv = import-csv $userfile -Delimiter ";" #Importação do CSV com nome de usuários, licenças, etc..
$AccountSku; #Variável que informa o grupo de licenças que deve ser utilizado..EX: F
 
 #Bloco de conexao ao Office365
################################################
Import-Module MSOnline
#Remove as possiveis sessoes ativas
Get-PSSession | Remove-PSSession

#Obtem as credenciais para logon
$Office365Credentials  = Get-Credential

#Cria a sessao remota do Powershell
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $Office365credentials -Authentication Basic -AllowRedirection

#Importa a sessao
write-host "Aguarde a criacao da sessao remota..."
Import-PSSession $Session -AllowClobber | Out-Null
Connect-MsolService -Credential $Office365Credentials
#################################################

foreach($line in $csv){
        #esse grande bloco de "if's" vai remover a licença do usuário caso o campo do app esteja como "disabled" no CSV importado
        #Nota: Como o comando de licenciamento leva em conta apenas o que deve ser desabilitado, não é necessário incluir um "else" nestas comparações.
        $DisabledPlans = @(); #Variável que será utilizada para informar as licenças que não devem ser habilitadas para o usuário.

        if($line.TEAMS1 -eq "Disabled"){$DisabledPlans +="TEAMS1"}
        if($line.INTUNE_O365 -eq "Disabled"){$DisabledPlans +="INTUNE_O365"}
        if($line.Deskless -eq "Disabled"){$DisabledPlans +="Deskless"}
        if($line.FLOW_O365_P2 -eq "Disabled"){$DisabledPlans +="FLOW_O365_P2"}
        if($line.POWERAPPS_O365_P2 -eq "Disabled"){$DisabledPlans +="POWERAPPS_O365_P2"}
        if($line.RMS_S_ENTERPRISE -eq "Disabled"){$DisabledPlans +="RMS_S_ENTERPRISE"}
        if($line.OFFICE_FORMS_PLAN_2 -eq "Disabled"){$DisabledPlans +="OFFICE_FORMS_PLAN_2"}
        if($line.PROJECTWORKMANAGEMENT -eq "Disabled"){$DisabledPlans +="PROJECTWORKMANAGEMENT"}
        if($line.SWAY -eq "Disabled"){$DisabledPlans +="SWAY"}
        if($line.YAMMER_EDU -eq "Disabled"){$DisabledPlans +="YAMMER_EDU"}
        if($line.OFFICESUBSCRIPTION -eq "Disabled"){$DisabledPlans +="OFFICESUBSCRIPTION"}
        if($line.SHAREPOINTWAC_EDU -eq "Disabled"){$DisabledPlans +="SHAREPOINTWAC_EDU"}
        if($line.SHAREPOINTSTANDARD_EDU -eq "Disabled"){$DisabledPlans +="SHAREPOINTSTANDARD_EDU"}
        if($line.EXCHANGE_S_STANDARD -eq "Disabled"){$DisabledPlans +="EXCHANGE_S_STANDARD"}
        if($line.MCOSTANDARD -eq "Disabled"){$DisabledPlans +="MCOSTANDARD"}        
        
        $AccountSku = $line.AccountSku; #define o grupo de licenciamento
        $myO365Sku1 = New-MsolLicenseOptions -AccountSkuId $AccountSku -DisabledPlans $DisabledPlans

            #True = Usuario ja licenciado, apenas ajuste de licenca
            #False = Usuario sem nenhuma licenca, novo licenciamento.
            if((Get-MsolUser -UserPrincipalName $line.UserPrincipalName).IsLicensed -eq "True"){
                Write-Host "Licenciando usuario: " $line.UserPrincipalName
                Set-MsolUserLicense -UserPrincipalName $line.UserPrincipalName -LicenseOptions $myO365Sku1

            }else{ 
                Set-MsolUser -UserPrincipalName $line.UserPrincipalName -UsageLocation BR
                Set-MsolUserLicense -UserPrincipalName $line.UserPrincipalName -AddLicenses $AccountSku -LicenseOptions $myO365Sku1
            }
           # $DisabledPlans ="";
            Clear-Variable -Name "DisabledPlans" #limpa o conteúdo da variável antes de prosseguir para o próximo usuário..
            Start-Sleep -m 100  #soneca
            
}

#(Get-MsolUser -UserPrincipalName testmbx07@unisinos.br).licenses.ServiceStatus #verificar licençacls

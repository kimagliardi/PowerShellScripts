Param(
    [String]$filePath
)
Import-module ActiveDirectory 
Import-CSV $filePath -Delimiter ";" | % { 


# Adiciona os usuário aos grupos
# Sintaxe: .\Add_Users_To_Group.ps1 <caminho_do_CSV>
# Deve ser executado com a conta de ADM_xxx
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned (para ativar a execução de scripts)
# Criar um arquivo CSV (delimitado por ";") com as colunas "UserName" e "GroupName"
# com os logins de usuários e os respectivos grupos
# UserName  GroupName
# User1     UNI_PAPP_FUNCIONARIO
# User2     UNI_GED_Alunos

param (
    [Parameter(Mandatory=$true)][string]$userfile
)


Import-CSV $userfile -Delimiter ";" | % { 
write-host "Importando #$($_.Username) - $($_.GroupName)"
Add-ADGroupMember -Identity $_.GroupName -Members $_.UserName 
} 

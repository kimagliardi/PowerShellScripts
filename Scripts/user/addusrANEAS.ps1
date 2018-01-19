param (
    [Parameter(Mandatory=$true)][string]$CsvFile
)
# Importa o modulo do active directory para executar os comandos
Import-Module activedirectory
  
#Armazena od dados do arquivo CSV na variavel $ADUsers
$ADUsers = Import-csv $CsvFile -delimiter ";" -encoding UTF7

#Loop para cada linha
foreach ($User in $ADUsers)
{
	#Le os dados de cada linha e armazena nas variaveis abaixo
		
	$DisplayName    = $User.Nome
	$Givenname      = $User.PrimNome	
	$Lastname 	    = $User.Sobrenome
	$Username 	    = $User.LOGIN
	$UPN            = $User.UPN
	$Password 	    = $User.CPF
	$OU 		    = $User.OUad
	$Mail		= $User.EMAIL
	$EID	= $User.CHAPA
        $Job = $User.FUNCAO
        $Dep = $User.SECAO

	New-ADUser `
            -Name $Username `
            -UserPrincipalName $UPN `
            -givenName $Givenname `
            -Surname $Lastname `
            -Enabled $True `
            -DisplayName "$Displayname" `
            -Path $OU `
            -PasswordNeverExpires $true `
            -Title "$Job" `
            -EmailAddress $Mail `
	    -Company "ANEAS" `
	    -EmployeeID $EID `
	    -Department "$Dep" `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force)
#		write-host "Criando usuario $Username em $OU"
}

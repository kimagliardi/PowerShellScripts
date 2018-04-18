param (
    [Parameter(Mandatory=$true)][string]$userfile
)

$csv = Import-csv $userfile -Delimiter ";"

foreach($line in $csv){
    #spliting identity line
    $id = $line.identity.Split(";")
    for($i=0; $i -lt $id.Length; $i++){
        Add-MailboxPermission -Identity $id[$i] -AccessRights FullAccess -InheritanceType All -AutoMapping:$true -User $line.User
        Write-Host "Adicionando permissão de caixa de correio em: " $id[$i] "para o usuário: " $line.user
    }
}

$csv = Import-csv 'C:\scripts\Lotes\Habilitar usuarios.csv' -Delimiter ";"
$path = cd "c:\Program Files\Microsoft\Exchange Server\V15\Scripts\"
$scripts = "c:\Scripts\"
$passcat = Get-Credential ("colegiocatarinense.g12.br\administrador"); #Montar diretório de scripts do exchang
$passasav = Get-Credential ("ASAV\administrator");
cd $path


foreach($line in $csv){
    .\Prepare-MoveRequest.ps1 -Identity $line.userPrincipalName -RemoteForestDomainController dcat01.colegiocatarinense.g12.br -RemoteForestCredential $passcat -LocalForestDomainController dc-ad1.asav.brm -LocalForestCredential $passasav -LinkedMailUser -UseLocalObject
}


cd $scripts
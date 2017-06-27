$csv = Import-Csv D:\PowerShellScripts\Temp\anc.csv -Delimiter ";"

foreach($line in $csv){
    Get-ADUser -Identity $line.name -Properties * | Select-Object `
    cn,sAMAccountName,employeeID,employeeNumber,employeeType,displayName,givenName,Company,mail,ProxyAddress,name,department,postalCode,sn,telephoneNumber,title,extensionAttribute1,homeDrive,homeDirectory,description,userPrincipalName,userAccountControl,memberOf `
    | Export-Csv D:\PowerShellScripts\Temp\ancAjuste.csv -Append -Encoding UTF8
}






    Get-ADUser -Identity kagliardi -Properties * | Select-Object `
    cn,sAMAccountName,employeeID,employeeNumber,employeeType,displayName,givenName,Company,mail,ProxyAddress,name,department,postalCode,sn,telephoneNumber,title,extensionAttribute1,homeDrive,homeDirectory,description,userPrincipalName,userAccountControl,memberOf

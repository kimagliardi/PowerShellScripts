$objSID = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-21-1380917689-3523811428-3782964912-65957")

Try {
    $User = $objSID.Translate( [System.Security.Principal.NTAccount]).Value
}
Catch {
    $User = $objSID.Value
}
$use

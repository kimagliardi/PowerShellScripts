$csv = Import-csv d:\migracao.csv


while($true){
    
    foreach ($line in $csv){
        Get-mailbox -Identity $line.Name | Get-mailboxStatistics | ft displayname, totalitemsize >> D:\progressoMigra.txt
    }
        [string]$newFileName = [DateTime]::Now.ToString("yyyyMMdd-HHmmss") + ".txt";
        
        Move-Item -LiteralPath D:\progressoMigra.txt -Destination d:\lotes\$newFileName;
     Start-Sleep -s 1800
}


[string]$filePath = "C:\tempFile.zip";

[string]$directory = [System.IO.Path]::GetDirectoryName($filePath);
[string]$strippedFileName = [System.IO.Path]::GetFileNameWithoutExtension($filePath);
[string]$extension = [System.IO.Path]::GetExtension($filePath);
[string]$newFileName = $strippedFileName + [DateTime]::Now.ToString("yyyyMMdd-HHmmss") + ".txt";
[string]$newFilePath = [System.IO.Path]::Combine($directory, $newFileName);

Move-Item -LiteralPath $d:\progressoMigra.txt -Destination $newFileName;



Get-mailbox -Identity <user> | Get-mailboxStatistics | Select-Object displayname, totalitemsize | ConvertTo-HTML |  Out-File d:\progressoMigra.htm

PS D:\PowersShellScripts> Get-mailbox -Identity <user> | Get-mailboxStatistics | Select-Object  Name, displayname, totalitemsize | ConvertTo-HTML |  Out-File d:\progressoMigra.h
tm
 Get-MailboxDatabaseStatistics | Select DisplayName, @{expression={$_.TotalItemSize.ValueToMB(); label="TotalItemSizeMB"}

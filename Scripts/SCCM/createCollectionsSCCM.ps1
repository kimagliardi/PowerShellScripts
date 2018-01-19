<#
Crafted by Maestro, 17/03/2017

The purposes of this script:
1. Create device collections in SCCM based on AD. Assign Canonical name of OU to collection
and OU GUID to collection description. I use OU GUID for my further needs, so you can omit this.
In addition, I think that Canonical name is the best variant to use in SCCM but you can pick simple 
Name or Distinguished Name - it is up to you

2. Define the Refresh Schedule of collection.
3. Create Query Rule for collection membership
4. Move created collection to custom folder (very handy, never saw this option in other scripts).
5. Updates collection membership at once.
#>

# Importing necessary PS modules
Import-Module ActiveDirectory
Import-Module 'C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1'

# Defining main variables
# SCCM Site
$Site = (Get-PSDRive -PSProvider CMSite).name
<# Folder to move collections into. I've selected the ready one. 
You can create new folder right in script with simple "mkdir" in "${Site}:\DeviceCollection\"
#>
$TargetFolder = "${Site}:\DeviceCollection\FromAD_by_OU"

# Relocating to SCCM PSDrive
cd ${Site}:

# Defining refresh interval for collection. I've selected 15 minutes period.
$Refr = New-CMSchedule -RecurCount 15 -RecurInterval Minutes -Start "01/01/2017 0:00"

<# Getting Canonical name and GUID from AD OUs. 
-SearchScope is Subtree by default, you can use it or use "Base" or "OneLevel".
OUs are listed from the root of AD. To change this i.e. to OU SomeFolder use -SearchBase "OU=SomeFolder,DC=maestro,DC=local"
#>
$ADOUs = Get-ADOrganizationalUnit -Filter * -Properties Canonicalname |Select-Object CanonicalName, ObjectGUID

# And at last, let's create some collections!

foreach ($OU in $ADOUs)
{
$O_Name = $OU.CanonicalName
$O_GUID = $OU.ObjectGUID

# Adding collection
New-CMDeviceCollection -LimitingCollectionName 'All Systems' -Name $O_Name -RefreshSchedule $Refr -Comment $O_GUID

# Creating Query Membership rule for collection
Add-CMDeviceCollectionQueryMembershipRule -CollectionName $O_Name -QueryExpression "select *  from  SMS_R_System where SMS_R_System.SystemOUName = '$O_Name'" -RuleName "OU Membership"

# Getting collection ID
$ColID = (Get-CMDeviceCollection -Name $O_Name).collectionid

# Moving collection to folder
Move-CMObject -FolderPath $TargetFolder -ObjectId "$ColID"

# Updating collection membership at once
Invoke-CMDeviceCollectionUpdate -Name $O_Name
}

Write-Host "----------------------------"
Write-Host "All done, have some beer! ;)"
Write-Host "----------------------------"
$computer = Read-Host "Informe o nome do computador: "

RENAME-COMPUTER -computername $env:COMPUTERNAME -NewName $computer

## Desabilitando opcões do IPv6 | Habilitando Ping
netsh int ipv6 isatap set state disabled
netsh int ipv6 6to4 set state disabled
netsh interface teredo set state disable
#Desabilitando ARP (apenas para VM's)
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters -Name ArpRetryCount -PropertyType DWORD -Value "0" –Force
#Desabilitando ipv6
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters -Name DisabledComponents -PropertyType DWORD -Value "4294967295" –Force
# Opcões de Firewall

Import-Module NetSecurity
New-NetFirewallRule -Name Allow_Ping -DisplayName “Allow Ping”  -Description “Packet Internet Groper ICMPv4” -Protocol ICMPv4 -IcmpType 8 -Enabled True -Profile Any -Action Allow
New-NetFirewallRule -Name Allow_Ping -DisplayName “Allow Ping”  -Description “File And Printer Sharing (Echo Request - ICMPv4-In)” -Protocol ICMPv4 -IcmpType 8 -Enabled True -Profile Any -Action Allow
## Desabilitando opcões na placa de rede
Disable-NetAdapterBinding -Name "Ethernet0" -ComponentID ms_rspndr
Disable-NetAdapterBinding -Name "Ethernet0" -ComponentID ms_lltdio
Disable-NetAdapterBinding -Name "Ethernet0" -ComponentID ms_implat
Disable-NetAdapterBinding -Name "Ethernet0" -ComponentID ms_pacer
Disable-NetAdapterBinding -Name "Ethernet0" -ComponentID ms_tcpip6

#Ajusta IP, mascara, gateway e DNS da estação (dom. "aneas.local")
$ipv4 = Read-Host "Informe o endereco IP do computador: "
$gateway = Read-Host "Informe o endereco do Gateway"
New-NetIPAddress -InterfaceAlias "Ethernet0" -IPAddress $ipv4 -PrefixLength 24 -DefaultGateway $gateway
Set-DnsClientServerAddress -InterfaceAlias "Ethernet0" -ServerAddresses 200.188.171.3, 200.188.170.3

# Desabilita opção "Enable LMHOSTS Lookup"
$nic = [wmiclass]'Win32_NetworkAdapterConfiguration'
$nic.enablewins($false,$false)

#Ajusta as configurações de netbios para "Enable NetBIOS over TCP/IP"
$nic = gwmi 'Win32_NetworkAdapterConfiguration'
$nic.settcpipnetbios(1)

#anexa sufixos de DNS
New-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\TCPIP\Parameters\ -Name SearchList -PropertyType String -Value "aneas.org.br,aneas.local" -Force
## Fim das opcões de rede


# Enable Remote Desktop
(Get-WmiObject Win32_TerminalServiceSetting -Namespace root\cimv2\TerminalServices).SetAllowTsConnections(1,1) | Out-Null
(Get-WmiObject -Class "Win32_TSGeneralSetting" -Namespace root\cimv2\TerminalServices -Filter "TerminalName='RDP-tcp'").SetUserAuthenticationRequired(0) | Out-Null
Get-NetFirewallRule -DisplayName "Remote Desktop*" | Set-NetFirewallRule -enabled true

## Ativação do Windows 2012 R2 std - Serial ASAV
$key = "inserir a chave do Windows"
$service = get-wmiObject -query “select * from SoftwareLicensingService”
$service.InstallProductKey($key)
$service.RefreshLicenseStatus()
## Fim do bloco de ativação do Windows

## Desabilita a exibição do server manager no startup
New-ItemProperty -Path HKCU:\Software\Microsoft\ServerManager -Name DoNotOpenServerManagerAtLogon -PropertyType DWORD -Value "0x1" –Force
## 
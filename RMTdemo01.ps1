<#

    Demo01 - Summit 2018 Troubleshooting remoting
             Richard Siddaway

             Need W16RMT01 running
             Remove existing checkpoints and then
             checkpoint W16RMT01 before starting demo
#>

<#
    NOTICE THE ERROR MESSAGES

    ERROR MESSAGES DON'T ALWAYS MATCH DOCUMENTATION
    
    ASSUMING THAT NETWORK CONNECTIVITY 
    TO REMOTE SYSTEM EXISTS AND HAS 
    BEEN CHECKED

    WON'T COVER DOUBLE HOP PROBLEM IN THIS SESSION
    USE CREDSSP OR SEE ASHLEY MCGLONE SESSION FROM
    SUMMIT 2017

#>

#region START
<#
  Remoting should just work
  Enabled by default in 
  Windows Server 2012 and above 
#>
$sb = {
  Get-CimInstance -ClassName Win32_OperatingSystem | 
  select Caption
}
$s = New-PSSession -ComputerName W16RMT01
Invoke-Command -Session $s -ScriptBlock $sb
Remove-PSSession -Session $s
#endregion START

#region scenario1
<# 
  #########################
  run scenario1 on W16RMT01
  #########################
#>
$s = New-PSSession -ComputerName W16RMT01

<# 
  ############################
  run FIXscenario1 on W16RMT01
  ############################
#>
#endregion scenario1

#region scenario2
<# 
  #########################
  run scenario2 on W16RMT01
  #########################
#>
$s = New-PSSession -ComputerName W16RMT01

<# 
  ############################
  run FIXscenario2 on W16RMT01
  
  IGNORE Set-WSManQuickConfig error
  ############################
#>

#endregion scenario2

#region scenario3
<# 
  #########################
  run scenario3 on W16RMT01
  #########################
#>
$s = New-PSSession -ComputerName W16RMT01

<# 
  ############################
  run FIXscenario2 on W16RMT01
  ############################
#>

#endregion scenario3

#region scenario4
<# 
  #########################
  run scenario4 on W16RMT01
  #########################
#>
$s = New-PSSession -ComputerName W16RMT01

<# 
  ############################
  run FIXscenario4 on W16RMT01
  ############################
#>

#endregion scenario4

#region scenario5
<# 
  #########################
  run scenario5 on W16RMT01
  #########################
#>
$s = New-PSSession -ComputerName W16RMT01

<# Possible errors

        ERROR:  ACCESS IS DENIED
        - or -
        ERROR: The connection to the remote host was refused. 
        Verify that the  WS-Management service is running on
        the remote host and configured to listen for 
        requests on the correct port and HTTP URL. 
#>

<# 
  ############################
  run FIXscenario5 on W16RMT01

  Enable-PSRemoting FAILS if a public network exists
  use the -SkipNetworkProfileCheck parameter
  ############################
#>

#endregion scenario5

#region scenario6
<# 
  #########################
  run scenario6 on W16RMT01
  #########################
#>
$s = New-PSSession -ComputerName W16RMT01

<# 
  ############################
  run FIXscenario6 on W16RMT01

  Enable-PSRemoting FAILS if a private network exists
  use the -SkipNetworkProfileCheck parameter
  ############################
#>

#endregion scenario6

#region scenario7
## https://blogs.msdn.microsoft.com/wmi/2009/07/22/new-default-ports-for-ws-management-and-powershell-remoting/

<# 
  #########################
  run scenario7 on W16RMT01
  also drops firewall 
  #########################
#>
$s = New-PSSession -ComputerName W16RMT01

$s = New-PSSession -ComputerName W16RMT01 -Port 8080

## can mix and match ports
$s2 = New-PSSession -ComputerName W16DC01

Invoke-Command -Session $s,$s2 -ScriptBlock $sb

Get-PSSession | Format-Table -AutoSize

Get-PSSession | Remove-PSSession
<# 
  ############################
  run FIXscenario7 on W16RMT01

  ############################
#>

#endregion scenario7


#region scenario8

$cred = Get-Credential -Credential manticore\billbell
$s = New-PSSession -ComputerName W16RMT01 -Credential $cred

<# 
  ############################
  run TestScenario8 on W16RMT01

  ############################
#>

#endregion scenario8


#region - connect by IP

$s = New-PSSession -ComputerName '10.10.54.73'

<# 
  ############################
  This is a client side issue
  Use trusted hosts or certificates
  ############################
#>

Start-Service winrm
Get-Item -Path wsman:localhost\client\trustedhosts

## documenation often says use *  - DON'T
Set-Item -Path wsman:localhost\client\trustedhosts -Value '10.10.54.73' -Force
Get-Item -Path wsman:localhost\client\trustedhosts 

$cred = Get-Credential -Credential manticore\richard
$s = New-PSSession -ComputerName '10.10.54.73' -Credential $cred
Invoke-Command -Session $s -ScriptBlock $sb 

Remove-PSSession -Session $s
Set-Item -Path wsman:localhost\client\trustedhosts -Value '' -Force 
Get-Item -Path wsman:localhost\client\trustedhosts 
#endregion - connect by IP

#region - non-domain

$s = New-PSSession -ComputerName W16ND01
Test-Connection -ComputerName W16ND01 -Count 1

<# 
  ############################
  This is a client side issue
  Use trusted hosts or certificates
  ############################
#>

##  
##  Port 5986 is standard for HTTPS access

Test-NetConnection -ComputerName W16ND01 -Port 5986

$cred = Get-Credential W16ND01\Administrator
$nd = New-PSSession -ComputerName W16ND01 -UseSSL -Credential $cred
$nd
Invoke-Command -Session $nd -ScriptBlock $sb

##
## need a HTTPS listener
##  first standard listener = HTTP
Get-ChildItem -Path WSMan:\localhost\Listener

## remote listeners
Invoke-Command -Session $nd -ScriptBlock {Get-ChildItem -Path WSMan:\localhost\Listener}

Invoke-Command -Session $nd -ScriptBlock {
Get-ChildItem -Path WSMan:\localhost\Listener\ | 
where Keys -like "*HTTPS*" | 
Format-List
}

<# 
  ############################
  To create an HTTPS listener

  ## get thumbprint
  $tp = Get-ChildItem -Path Cert:\LocalMachine\My\ |
  where Subject -eq 'CN=W16ND01' |
  select -ExpandProperty Thumbprint

  ## create listener
  New-WSManInstance -ResourceURI winrm/config/Listener `
  -SelectorSet @{Address="*";Transport="HTTPS"} `
  -ValueSet @{HostName="W16ND01";CertificateThumbprint="$tp"}

  ## may need firewall rule to allow HTTPS remoting
  ##  TO CHECK:
  ##   port based rule for 5986
  $pr = Get-NetFirewallPortFilter -Protocol TCP  | 
  where LocalPort -eq 5986

  Get-NetFirewallRule -AssociatedNetFirewallPortFilter $pr

  ############################
#>

Remove-PSSession -Session $nd
#endregion - non-domain

#region OTHER

<#
    ERROR: The WS-Management service cannot complete the operation 
    within the time specified in OperationTimeout.


    FIX: modify timeout settings - client and server as shortest is used
    OR use timeout options in New-PSsessionOption
#>


<#
    ERROR: The total data received from 
    the remote client exceeded allowed maximum.


    FIX: modify quota settings 
    OR use options in New-PSsessionOption
#>

Get-Command New-PSSessionOption -Syntax

#endregion OTHER
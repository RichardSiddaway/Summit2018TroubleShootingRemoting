<#

    Remoting Tests - Summit 2018 Troubleshooting remoting
                    Richard Siddaway

                    Run on box with problems

#>

$stat = Get-Service -Name WinRM | select -ExpandProperty Status

Describe 'WinRM' {
##  tests WinRM service is Running 
  It 'WinRM should be running' {
     $stat | 
    Should Be 'Running'
 
  }
}

Describe 'Listener' {
## tests listener available
 It 'Listener is available' { 
    Test-Path -Path WSMan:\localhost\Listener\listener* |
    Should Be $true
 }
}

## default listener is usually Listener_1084132640
##   but just in case its not
if ($stat -eq 'Running' -AND (Test-Path -Path WSMan:\localhost\Listener\listener*) ) {
  $listeners = Get-ChildItem -Path WSMan:\localhost\Listener\
  $path = $listeners[0].PSPath
}

Describe 'Listener Enabled' {
## tests listener enabled
 It 'Listener is Enabled' { 
    Get-Item -Path "$path\Enabled" |
    select -ExpandProperty Value |
    Should Be $true
 }
 }
 
Describe 'Transport' {
## tests listening on correct protocol
 It 'Transport is HTTP' { 
    Get-Item  "$path\Transport" | 
    select -ExpandProperty Value |
    Should Be 'HTTP'
 }
}

Describe 'Address' {
## tests listening on correct address
 It 'Address is *' { 
    Get-Item  "$path\Address" | 
    select -ExpandProperty Value |
    Should Be '*'
 }
}

Describe 'Port' {
## tests listening on correct remoting port
 It 'Remoting Port is 5985' { 
    Get-Item  "$path\Port" | 
    select -ExpandProperty Value |
    Should Be '5985'
 }
}

Describe 'EndPoint Exists' {
## tests end point exists
 It 'End Point Exists' { 
    Test-Path -Path WSMan:\localhost\Plugin\microsoft.powershell |
    Should Be $true
 }
}

Describe 'EndPoint Enabled' {
## tests end point enabled
 It 'EndPoint is Enabled' { 
    $ev = Get-Item -Path WSMan:\localhost\Plugin\Microsoft.PowerShell\Enabled | 
    select -ExpandProperty Value 
    [System.Convert]::ToBoolean($ev)  |
    Should Be $true
 }
}

Describe 'Firewall Enabled' {
## tests firewall rule enabled
 It 'Firewall rule is enabled' { 
    Get-NetFirewallRule -Name 'WINRM-HTTP-In-TCP' | 
    where Profile -like "*Domain*" |
    select -ExpandProperty Enabled |
    Should Be $true
 }
}

Describe 'Firewall Allows' {
## tests firewall rule set to Allow
  It 'Firewall rule set to Allow' { 
    Get-NetFirewallRule -Name 'WINRM-HTTP-In-TCP' | 
    where Profile -like "*Domain*" |
    select -ExpandProperty Action |
    Should Be 'Allow'
 }
}

Describe 'Remoting Enabled' {
## tests if remoting enabled - i.e. has someone run Disable-PSRemoting
  It 'PowerShell Remoting Enabled' {
    (Get-PSSessionConfiguration -Force -Name 'Microsoft.PowerShell' | 
    select -ExpandProperty permission) -match 'NT AUTHORITY\\NETWORK AccessDenied' | 
    Should Be $false
  }
}
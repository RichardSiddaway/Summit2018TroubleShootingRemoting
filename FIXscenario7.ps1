<#

 FIX Scenario7 - Summit 2018 Troubleshooting remoting
                Richard Siddaway

                Reset port
                Restart winrm
                Restore firewall
#>
Get-Content ./Fixscenario7.ps1

Set-Item wsman:\localhost\listener\listener*\port -Value 5985 -Force

## restart winrm
Restart-Service -Name WinRM

## bring  the firewall backup
Get-NetFirewallProfile | Set-NetFirewallProfile -Enabled True
<#

 FIX Scenario4 - Summit 2018 Troubleshooting remoting
                Richard Siddaway

                Reset Firewall
#>
Get-Content ./Fixscenario4.ps1

Set-NetFirewallRule -DisplayName 'Windows Remote Management (HTTP-In)' -Profile Domain -Action Allow
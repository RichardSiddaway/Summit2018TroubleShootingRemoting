<#

    Scenario7 - Summit 2018 Troubleshooting remoting
                Richard Siddaway

                Change port
#>

Set-Item wsman:\localhost\listener\listener*\port -Value 8080 -Force

## drop the firewall for simplicity
Get-NetFirewallProfile | Set-NetFirewallProfile -Enabled False
<#

    Scenario4 - Summit 2018 Troubleshooting remoting
                Richard Siddaway

                Firewall blocks remoting
#>
Set-NetFirewallRule -DisplayName 'Windows Remote Management (HTTP-In)' -Profile Domain -Action Block
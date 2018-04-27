<#

 FIX Scenario1 - Summit 2018 Troubleshooting remoting
                Richard Siddaway

                Start WinRm service
#>
Get-Content ./Fixscenario1.ps1

Start-Service -Name WinRm | Out-Null
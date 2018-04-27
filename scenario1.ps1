<#

    Scenario1 - Summit 2018 Troubleshooting remoting
                Richard Siddaway

                Stops WinRm service
#>

Stop-Service -Name WinRm | Out-Null
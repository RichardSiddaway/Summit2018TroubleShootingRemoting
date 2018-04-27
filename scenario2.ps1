<#

    Scenario2 - Summit 2018 Troubleshooting remoting
                Richard Siddaway

                Delete Listener
#>
Get-Item  -Path  WSMan:\localhost\Listener\Listener_1084132640 | Remove-Item -Recurse -Force -Confirm:$false
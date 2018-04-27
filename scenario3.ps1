<#

    Scenario3 - Summit 2018 Troubleshooting remoting
                Richard Siddaway

                Delete EndPoint
#>
Remove-Item -Path WSMan:\localhost\Plugin\microsoft.powershell -Recurse -Force -Confirm:$false

## this has the same effect
## Unregister-PSSessionConfiguration -Name Microsoft.PowerShell
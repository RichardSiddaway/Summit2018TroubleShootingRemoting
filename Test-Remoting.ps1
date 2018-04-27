$tests = 'WinRM', 'Listener', 'Listener Enabled', 'Transport', 'Address',
 'Port', 'EndPoint Exists', 'EndPoint Enabled', 'Firewall Enabled', 'Firewall Allows',
 'Remoting Enabled'

$data = foreach ($test in $tests) {
$result = $null
$result = Invoke-Pester -Script @{Path = '.\RemotingTests.ps1'} -PassThru -TestName "$test" -Show None #-EnableExit

$props = [ordered]@{
    'Test' = $result.TestResult.Name
    'Result' = $result.TestResult.Result
    'Failue Message' = $result.TestResult.FailureMessage
  }
 New-Object -TypeName PSObject -Property $props

if ($result.FailedCount -gt 0) {break}
} 

$data | Format-Table -AutoSize -Wrap

<#
## Now dump the listener information
Write-Information -MessageData "Expected Listener is Listener_1084132640" -InformationAction Continue
Get-ChildItem -Path WSMan:\localhost\Listener
#>
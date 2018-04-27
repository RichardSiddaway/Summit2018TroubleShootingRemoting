'Default permissions on Microsoft.PowerShell'  

(Get-PSSessionConfiguration -Force -Name 'Microsoft.PowerShell' | 
select -ExpandProperty permission) -split ','

"`n`nLocal administrators"
Get-LocalGroupMember -Group Administrators

"`n`nLocal Remote Management Users"
Get-LocalGroupMember -Group 'Remote Management Users'

"`n`nUser group membership"
Get-ADUser -Identity billbell -Properties memberof, PrimaryGroup | 
select MemberOf, PrimaryGroup

pause

"`n`nUser must have execute permissions on endpoint"
Set-PSSessionConfiguration Microsoft.PowerShell -ShowSecurityDescriptorUI
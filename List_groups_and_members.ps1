$groups = Get-ADGroup -Filter "GroupCategory -eq 'security'" -SearchBase 'OU=Groups,DC=corp,DC=test,DC=local'

Get-ADUser -Filter * -SearchBase "dc=corp,dc=test,dc=local" -Properties MemberOf | ForEach-Object {
  $props = [ordered]@{ 'Username' = $_.UserPrincipalName }
  $groups | ForEach-Object {
    $props[$_.Name] = $false
  }

  $_.MemberOf | Get-ADGroup | Select-Object -Expand Name | ForEach-Object {
    if ($props.ContainsKey($_)) {
      $props[$_] = $true
    }
  }

  New-Object -Type PSObject -Property $props
}
Get-ADGroup -Filter * -Properties CanonicalName,Cn,Created,createTimeStamp,Deleted,Description,member,GroupCategory,GroupScope|Select-Object CanonicalName,Cn,Created,createTimeStamp,Deleted,Description,@{N='member';E={$_.member[0]}},GroupCategory,GroupScope|Select -First 10

Export-Csv C:\AD-Group_2018_0910.csv

 Get-ADUser -properties departmentnumber |
    Select-Object Name,SamAccountName,@{N='Departmentnumber';E={$_.Departmentnumber[0]}} | 
    Export-Csv "C:\userdeptno.csv"
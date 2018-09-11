$File='C:\Users and Groups.txt'
$Date= Get-Date -Format G 
 Write-output 'Listado de Usuarios y sus grupos'|Out-File -FilePath $File -Append
 Write-output '============='|Out-File -FilePath $File -Append
 Write-output 'Fecha:'$Date.ToString()|Out-File -FilePath $File -Append
 Write-output "Generado por:"$env:USERNAME'-'$env:COMPUTERNAME|Out-File -FilePath $File -Append
 Write-output '============='|Out-File -FilePath $File -Append
$Users = Get-ADUser -filter * -Properties memberof 
ForEach($User in $Users)
   {
	$Groups = $User.Memberof
	write-host $User.Name
	write-host "___________________________"
	ForEach($Group in $Groups)
	{	 
	 Write-host $Group
	}
	
   }
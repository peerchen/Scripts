
$File='C:\GroupNGroupMembers.txt'
$Date= Get-Date -Format G 
 Write-output 'Listado de Grupos y sus Miembros'|Out-File -FilePath $File -Append
 Write-output '============='|Out-File -FilePath $File -Append
 Write-output 'Fecha:'$Date.ToString()|Out-File -FilePath $File -Append
 Write-output "Generado por:"$env:USERNAME'-'$env:COMPUTERNAME|Out-File -FilePath $File -Append
 Write-output '============='|Out-File -FilePath $File -Append
$Groups = Get-ADGroup -Properties * -Filter * 
Foreach($G In $Groups)
{
    Write-output '-------------'|Out-File -FilePath $File -Append
    Write-output 'Grupo: '|Out-File -FilePath $File -Append
    Write-output '-------------'|Out-File -FilePath $File -Append
    Write-output $G.Name|Out-File -FilePath $File -Append
    Write-output $G.CanonicalName|Out-File -FilePath $File -Append
    Write-output '-------------'|Out-File -FilePath $File -Append
    Write-output 'Creado: '$G.whenCreated.ToString()|Out-File -FilePath $File -Append
    Write-output 'Modificado: '$G.whenChanged.ToString()|Out-File -FilePath $File -Append
    Write-Output $G.ManagedBy|Out-File -FilePath $File -Append
    Write-output '-------------'|Out-File -FilePath $File -Append
    Write-output `n'Miembros: '|Out-File -FilePath $File -Append
    Write-output '-------------'|Out-File -FilePath $File -Append
    Write-output $G.Members|Out-File -FilePath $File -Append

}


Get-ADUser -filter * -Properties memberof,name | select -ExpandProperty memberof, name


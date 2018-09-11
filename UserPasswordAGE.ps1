#Script para generar información de usuarios de AD.
#V1.0 Versión Base de Hey Script Guy!
#V2.0 Se incluyeron campos enabled, distiguishedname,passwordexpired. 04.07.2018
#V2.1 Se incluyó el campo memberof y el tratamiento de la colección de datos.10.09.2018
import-module activedirectory
$default_log = $env:userprofile + '\Desktop\User_Password_Age4.csv'
 
#enumerate all the domain in a forest
foreach($domain in (get-adforest).domains){
    #query all users except critical system objects
    #To list all users change "-LDAPFIlter ..." for "-filter *"
    get-aduser -LDAPFilter "(!(IsCriticalSystemObject=TRUE))" `
    -properties enabled,description,whencreated,whenchanged,lastlogontimestamp,PwdLastSet,PasswordExpired,DistinguishedName,servicePrincipalName,memberof `
    -server $domain | Where-Object {($_.Enabled -eq 'True')} |`
    select @{name='Dominio';expression={$domain}},`
    @{name='Cuenta';expression={$_.SamAccountName}},`
    @{name='Comentario';expression={$_.description}},`
    @{name='Activa';expression={$_.enabled}},`
    @{name='Expirada';expression={$_.PasswordExpired}},`
    @{Name="Ult_Cambio_Pass";Expression={[datetime]::FromFileTime($_.PwdLastSet)}}, `
    @{Name="Edad_Pass(Dias)";Expression={if($_.PwdLastSet -ne 0){(new-TimeSpan([datetime]::FromFileTimeUTC($_.PwdLastSet)) $(Get-Date)).days}else{0}}}, `
    @{Name="Ult_Inicio_Sesion";Expression={[datetime]::FromFileTime($_.LastLogonTimeStamp)}}, `
    @{name='Fecha_Modificacion.';expression={$_.whenchanged}},`
    @{name='Fecha_Creacion';expression={$_.whencreated}},`
    @{Name="Servicio_Asociado";Expression={if($_.servicePrincipalName){$True}else{$False}}}, `
    @{Name="Miembro_De";Expression={$_.memberof -join "`n"}}, `
    @{name='Nombre_AD';expression={$_.distinguishedname}}| export-csv $default_log -NoTypeInformation
}


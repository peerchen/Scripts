	
 $outlook = New-Object -comobject outlook.application
 $namespace = $outlook.GetNameSpace("MAPI")
 $date1="7/1/2018"
 $date2="7/31/2018"
 
 
 $DefaultFolder = $namespace.GetDefaultFolder(6)
 $InboxFolders = $DefaultFolder.Folders
 $DeletedItems = $namespace.GetDefaultFolder(3)
 
 $Folders = $namespace.Folders.Item(1).Folders
 $Folders | ft Name
 foreach($folder in $folders)
 {
 
 $fold = $folder.Name
 $nagiosFolder=$namespace.Folders.Item(1).Folders.Item("$fold")
 $Emails = $nagiosFolder.Items
 
 Write-Host checking in $fold
 $Name = $fold
Foreach ($Email in $Emails)
{
 
 
 $Email.SaveAs("c:\temp\$($Email.Senton.ToFileTime()).msg") | out-null
 $Email |Select-Object -Property Subject, ReceivedTime, Importance, ReceiverName,SenderName, Body,CC,To,`
 @{n='Folder';e={$Name}},@{n='Reference';e={$Email.SentOn.ToFileTime()}} |select Subject, ReceivedTime, `
 SenderName, CC, To, Folder,Reference|where-object { ($_.ReceivedTime -gt $date1) -and ($_.ReceivedTime -lt $date2)} | `
 Export-Csv -Path C:\Elías\2018\Controles_Generales\Emails_report.csv -Force -Append
 Write-host -ForegroundColor Green " " $Email.SentOn " :`t" $Email.Subject
 
 
 }
 }



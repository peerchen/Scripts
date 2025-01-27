Get-WmiObject -query "select NumberOfCores from Win32_Processor"
Get-WmiObject -query “select Name,Status from Win32_PnPEntity”
Get-WmiObject -query “select * from Win32_PnPEntity” | Select-Object Name, Status
Get-WmiObject -query "select * from Win32_PnPEntity where caption like '%cam%'"
Get-WmiObject -query "select * from win32_service where state='Running'"
Get-WmiObject -query "select * from win32_service"
Get-WmiObject -query "select * from win32_useraccount"
Get-EventLog -LogName Security -EventId in(4740,4767,4723) -After (Get-Date).AddDays(-1)

Get-EventLog security |format-list >> E:\Eventlogs_security.txt

Get-WmiObject Win32_Share | Select Name, Path, Type | FT

Get-WmiObject Win32_LogicalDisk | Select Name, Size, FreeSpace

Get-Acl |format-list

net user /domain

Get-WmiObject -query "select * from win32_service"
get-wmiobject -list >>E:\wmiobject_list.txt

get-wmiobject -list | Where { $_.name -like '*Viewer*'}

ipmo grouppolicy
Get-GPResultantSetOfPolicy -ReportType xml


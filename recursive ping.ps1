$default_log = 'C:\Elías\2018\Canales_electrónicos\PING.txt'
$machine=Get-Content -Path 'C:\Elías\2018\Canales_electrónicos\ATM ping availability\IP_LIST.txt'
foreach($m in $machine){Test-connection -IPAddress $m -count 1 | export-csv $default_log -NoTypeInformation}
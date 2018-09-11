
$IPNodes = Get-Content "C:\Elías\2018\Canales_electrónicos\ATM_ping _availability\IP_LIST.txt"


foreach ($IP in $IPNodes)
{
if (Test-Connection -IPAddress $IP -Count 1 -Quiet)
{
"$IP is UP";
}
Else
{
"$IP is Down";
}

}

Stop-Transcript

Start-Transcript 'C:\Elías\2018\Canales_electrónicos\Ping_IP_LIST.txt'

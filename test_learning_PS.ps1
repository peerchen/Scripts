write-host "Hello World" -Foreground Yellow -BackgroundColor Black
[int] $a=5
[int] $b=5
$a+$b

[double] $c=4.5
[double] $d=3.5
$c-$d

#read-host "What is your name?"

[string]$e="4"
[int]$f=7
$e+$f
$f+$e

$a.GetType() 

$i="cheese" 
$i[0]
$i[4]
$i.Length

$array= Get-ChildItem

($array).Count

 Get-ADComputer -Filter 'Name -like "c30317*"' -Properties *

 Test-Connection -IPAddress "192.168.41.34"

 ping -a 192.168.41.34
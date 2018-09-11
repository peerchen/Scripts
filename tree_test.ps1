$Path1 = $env:userprofile + '\Desktop\output.txt'
$Path2 = "C:\Elías\2018\Controles_Generales"
Tree $Path2 /F | Select-Object -Skip 2 | Set-Content $Path1


Get-Help Select-Object
Remove-Module -ModuleInfo $i
Get-Module | Remove-Module -Force

$a= Get-InstalledModule 
$a[46].Name

$i= $a= Get-InstalledModule -Name $a[46].Name
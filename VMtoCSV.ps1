#Connect-AzAccount

#guardar todas las subscripciones
$Subxs=Get-AzSubscription

$path = read-host "coloca una direccion en tu equipo"  

Add-Content -Path  $path  -Value '"ID","NombreVM","ResourceGroup","subscripcion", "TamaÃ±o","sistema operativo","version", "versiÃ³n","iPrivada","ipPÃºblica","estado","tiempo","red", "subred","dns"'


foreach($Subx in $Subsx)
{
 Set-AzContext -SubscriptionId $Subx
#Get-AzContext

##Obtener todas las mÃ¡quinas virtuales

$vms =  get-azvm

#Obtener todas las interfaces de red

$nics = get-aznetworkinterface | where VirtualMachine -NE $null 

$psObject= foreach($nic in $nics)
    {
    $vm = $vms | where-object -Property Id -EQ $nic.VirtualMachine.id   
    $rg = $vm.ResourceGroupName
    $nic
    $vmst=Get-AzVM -ResourceGroupName $rg -Name $vm.Name -Status
    $zs = $vm.HardwareProfile.VmSize
    $os = $vm.StorageProfile.ImageReference.Sku 
    $0s2=$vm.StorageProfile.ImageReference.Offer
    $0s3=$vm.StorageProfile.ImageReference.Version 
    $avset=$vm.AvailabilitySetReference.Id
    $prvip =  $nic.IpConfigurations | select-object -ExpandProperty PrivateIpAddress
    $alloc =  $nic.IpConfigurations | select-object -ExpandProperty PrivateIpAllocationMethod
    $pip =  $nic.IpConfigurations | select-object -ExpandProperty PublicIpAddress
    
        if (!$pip) 
            {
            $publicIp = "sin ip publica"
            }
        else 
            {
             $Publicipname= $pip.Id.Split("/")[8]
            $pupp = Get-AzPublicIpAddress -Name $Publicipname -ResourceGroupName $rg
            $publicIp = $pupp.IpAddress
            $dns =$pip.DnsSettings

             }

    
    $VNet =  $nic.IpConfigurations.Subnet.Id.Split("/")[8]
    $SubNet =  $nic.IpConfigurations.Subnet.Id.Split("/")[10]
    $nsg=$nic.IpConfigurations | select-object -ExpandProperty ApplicationSecurityGroups
 #imprimir
    $print = @(" $idnum, $($vm.Name) ,$rg,$($Subx.Name),$zs,$0s2, $os, $0s3,$prvip, $publicIp, $($($vmst.Statuses[(($($vmst.Statuses).Length)-1)]).DisplayStatus),$Vnet,$SubNet,$dns" ) 
    $idnum++
    $print | foreach { Add-Content -Path $path -Value $_ }

    }
    }
 

 

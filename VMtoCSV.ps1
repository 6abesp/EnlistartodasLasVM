#Connect-AzAccount

#guardar todas las subscripciones

$path = read-host "coloca una direccion en tu equipo"  



 Set-AzContext -SubscriptionId $Subx
#Get-AzContext


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
    $idnum++
    $print | foreach { Add-Content -Path $path -Value $_ }

    }
 

 

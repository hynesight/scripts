$rgName                = "Resource Group"

$vnetrgName            = "Resource Group"

$storageAccName        = "prmpoolwrx03"

$COmputerName          = "sh01"

$urlOfCapturedImageVhd = "url of image file .VHD"

$location              = "Australia East"

$vmName                = "sh01"

$osDiskName            = "sh01-OS"

#Enter a new user name and password in the pop-up for the following

$cred = Get-Credential

# Set the existing virtual network and subnet index

$vnetName="vnet2"

$subnetIndex=0

$vnet=Get-AzureRMVirtualNetwork -Name vnet -ResourceGroupName $vnetrgName

# Create the NIC.

$nicName="sh01-nic"

# Leave this out for the time being
# $pip=New-AzureRmPublicIpAddress -Name $nicName -ResourceGroupName $DestRGName -Location $location -AllocationMethod Dynamic

$nic=New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $location -SubnetId $vnet.Subnets[$subnetIndex].Id # -PublicIpAddressId $pip.Id

#Get the storage account where the captured image is stored
$storageAcc = Get-AzureRmStorageAccount -ResourceGroupName $RGName -AccountName $storageAccName

#Set the VM name, size and availability set
$vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize "Standard_DS2_v2"

#Set the Windows operating system configuration and add the NIC

$vm = Set-AzureRmVMOperatingSystem -VM $vmConfig -Windows -ComputerName $computerName -Credential $cred -ProvisionVMAgent -EnableAutoUpdate

$vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id

#Create the OS disk URI

$osDiskUri = '{0}vhds/{1}{2}.vhd' -f $storageAcc.PrimaryEndpoints.Blob.ToString(), $vmName.ToLower(), $osDiskName

#Configure the OS disk to be created from image (-CreateOption fromImage) and give the URL of the captured image VHD for the -SourceImageUri parameter.

#We found this URL in the local JSON template in the previous sections.

$vm = Set-AzureRmVMOSDisk -VM $vm -Name $osDiskName -VhdUri $osDiskUri -CreateOption fromImage -SourceImageUri $urlOfCapturedImageVhd -Windows

#Create the new VM

New-AzureRmVM -ResourceGroupName $rgName -Location $location -VM $vm
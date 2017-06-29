$vmName = "[VMNAME]"
$rgName = "[RESOURCEGROUPNAME]"
$vm = Get-AzureRmVM -ResourceGroupName $rgName -Name $vmName
$vm.OSProfile.Secrets = New-Object -TypeName "System.Collections.Generic.List[Microsoft.Azure.Management.Compute.Models.VaultSecretGroup]" 
Update-AzureRmVM -ResourceGroupName $rgName -VM $vm -Debug
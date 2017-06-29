workflow Start-AzureRMVM
{
Param(
    [Parameter(Mandatory=$true)]
    [string]
    $ResourceGroupName,
    
    [Parameter(Mandatory=$true)]
    [string]
    $VM
)
$Cred = Get-AutomationPSCredential –Name '[AUTOMATION CREDENTIAL NAME]'

Add-AzureRMAccount -Credential $Cred

Select-AzureRMSubscription '[SUBSCRIPTION NAME]'

Start-AzureRMVM -ResourceGroupName $ResourceGroupName -Name $VM
}

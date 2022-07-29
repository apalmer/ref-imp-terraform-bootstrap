param( 
    $subscriptionId = "9247ed7a-b968-41cf-9104-9177a53aefd6",
    $servicePrincipalName = "sp-iac-refimp",
    $location = "centralus",
    $resourceGroupName = "rg-iac-refimp-tfstate",
    $storageAccountName = "saiacrefimp",
    $containerName = "tfstate",
    $secretManagementVault = "KeyVault"
)

$servicePrincipalInfo = & "$PSScriptRoot\Initialize-ServicePrincipal.ps1" -subscriptionId $subscriptionId  -servicePrincipalName $servicePrincipalName 

if ($secretManagementVault) {
    Set-Secret -Name "refimp-iac-service-principal-appid" -Secret $servicePrincipalInfo.AppId -Vault $secretManagementVault
    Set-Secret -Name "refimp-iac-service-principal-name" -Secret $servicePrincipalInfo.Name -Vault $secretManagementVault
    Set-Secret -Name "refimp-iac-service-principal-password" -Secret $servicePrincipalInfo.Password -Vault $secretManagementVault
    Set-Secret -Name "refimp-iac-service-principal-tenant" -Secret $servicePrincipalInfo.Tenant -Vault $secretManagementVault
} else {
    Write-Host "Service Principal AppId: $servicePrincipalInfo.AppId"
    Write-Host "Service Principal Name: $servicePrincipalInfo.Name"
    Write-Host "Service Principal Password: $servicePrincipalInfo.Password"
    Write-Host "Service Principal Tenant: $servicePrincipalInfo.Tenant"
}

$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $servicePrincipalInfo.Name, $servicePrincipalInfo.Password

$stateContainerInfo = & "$PSScriptRoot\Initialize-StateContainer.ps1" -credentials $credentials -tenantId $servicePrincipalInfo.Tenant -subscriptionId $subscriptionId -location $location -resoureGroupName $resourceGroupName -storageAccountName $storageAccountName -containerName $containerName

if ($secretManagementVault) {
    Set-Secret -Name "refimp-iac-state-sa-name" -Secret $stateContainerInfo.Name -Vault $secretManagementVault
    Set-Secret -Name "refimp-iac-state-sa-container-name" -Secret $stateContainerInfo.ContainerName -Vault $secretManagementVault
    Set-Secret -Name "refimp-iac-state-sa-access-key" -Secret $stateContainerInfo.AccessKey -Vault $secretManagementVault
} else {
    Write-Host "State Container Name: $stateContainerInfo.Name"
    Write-Host "State Container Container Name: $stateContainerInfo.ContainerName"
    Write-Host "State Container Access Key: $stateContainerInfo.AccessKey"
} 

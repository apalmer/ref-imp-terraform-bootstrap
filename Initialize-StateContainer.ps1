param (
    $credentials = (Get-Credential),
    $subscriptionId = "9247ed7a-b968-41cf-9104-9177a53aefd6",
    $tenantId = "72f988bf-86f1-41af-91ab-2d7cd011db8",
    $location = "centralus",
    $resoureGroupName = "rg-iac-refimp-tfstate",
    $storageAccountName = "saiacrefimp",
    $containerName = "tfstate"
)

Connect-AzAccount -ServicePrincipal -Credential $credentials -Tenant $tenantId -Subscription $subscriptionId

$resourceGroup = Get-AzResourceGroup -Name $resoureGroupName -Location $location
if(-not($resourceGroup)) {
    $resourceGroup = New-AzResourceGroup -Name $resoureGroupName -Location $location
}

$storageAccount = Get-AzStorageAccount -Name $storageAccountName -ResourceGroupName $resourceGroup.Name
if(-not($storageAccount)) {
    $storageAccount = New-AzStorageAccount -Name $storageAccountName -ResourceGroupName $resourceGroup.Name -Location $location -SkuName Standard_RAGRS -Kind StorageV2
}

$storageAccountContainer = Get-AzStorageContainer -Name $containerName -StorageAccount $storageAccount -ResourceGroupName $resourceGroup.Name
if(-not($storageAccountContainer)) {
    $storageAccountContainer = New-AzStorageContainer -Name $containerName -StorageAccount $storageAccount -ResourceGroupName $resourceGroup.Name
}

$storageAccountKey = (Get-AzStorageAccountKey -StorageAccount $storageAccount -ResourceGroupName $resourceGroup.Name).PrimaryKey

[PSCustomObject]@{
    Name = $storageAccount.StorageAccountName;
    ContainerName = $storageAccountContainer.Name;
    AccessKey = $storageAccountKey;
}
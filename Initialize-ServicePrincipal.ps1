param (
    $subscriptionId = "9247ed7a-b968-41cf-9104-9177a53aefd6",
    $servicePrincipalName = "sp-iac-refimp"
)

$servicePrincipal = Get-AzADServicePrincipal -DisplayName $servicePrincipalName 
if(-not($servicePrincipal)) {
    $servicePrincipal = New-AzADServicePrincipal -DisplayName $servicePrincipalName -Role 'Contributor' -Scope "/subscriptions/$subscriptionId"
} 

[PSCustomObject]@{
    AppId = $servicePrincipal.AppId;
    Name = $servicePrincipal.DisplayName;
    Password = $servicePrincipal.PasswordCredentials.SecretText;
    Tenant = (Get-AzContext).Tenant.Id;
}
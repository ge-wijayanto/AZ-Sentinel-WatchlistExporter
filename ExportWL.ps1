$SubscriptionId = " " # SubscriptionId, found in the Azure Portal (https://learn.microsoft.com/en-us/azure/azure-portal/get-subscription-tenant-id)
$ResourceGroupName = " " # Resource Group Name with the Workspace containing the Watchlist 
$WorkspaceName = " " # Workspace Name from which the watchlist is going to be extracted 
$WatchlistName = " " # Name of the watchlist to be exported
$ApiVersion = "2022-12-01-preview" # Leave as is
$OutputFilePath = "ExportedWatchlist.json" # Name of the JSON export files

# Get Azure access token
$accessToken = (Get-AzAccessToken -ResourceUrl https://management.azure.com).Token

$uriBase = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OperationalInsights/workspaces/$WorkspaceName/providers/Microsoft.SecurityInsights/watchlists/$WatchlistName/watchlistItems"

do {
    $uriBuilder = [System.UriBuilder]::new($uriBase)
    $uriBuilder.Query = "api-version=$ApiVersion"

    try {
        # Invoke the Azure REST method and include the Authorization header
        $response = Invoke-RestMethod -Method Get -Uri $uriBuilder.Uri -Headers @{ Authorization = "Bearer $accessToken" } -ErrorAction Stop

        # Check if the 'value' property is present in the response
        if ($response.value) {
            foreach ($item in $response.value) {
                # Access the 'properties' property and append to the output file
                $properties = $item.properties | Select-Object -Property *
                $properties | Out-File -FilePath $OutputFilePath -Append -Force
            }

            # Check if there is a 'nextLink' property indicating more data
            $nextLink = $response.nextLink
            if ($nextLink) {
                $uriBase = $nextLink
            }
        } else {
            # If 'value' is not present, exit the loop
            $nextLink = $null
        }
    } catch {
        Write-Host "Error invoking Azure REST method: $_"
        $nextLink = $null
    }
} while ($nextLink)

Write-Host "Data retrieval complete. Results have been appended to $OutputFilePath"
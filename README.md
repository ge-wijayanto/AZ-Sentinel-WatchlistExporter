# Azure Sentinel Watchlist Exporter (ASWE)

Azure Sentinel Watchlist Exporter is a custom powershell script that was created to help the process of exporting/extracting Watchlist data from Microsoft Azure Sentinel, in a fully automated and complete manner.

## Description
Microsoft Azure Sentinel is Microsoft's proprietary SIEM platform that has many features, ranging from the basic SIEM functionality up to AI and automation. One of the many great features that is a concern upon writing this script is the ability to create and manage Watchlists (A collected list of things to monitor or "watch", e.g. IoCs, Geolocation mappings of an IP, etc.).

However great and all it is, there are limitations in the area of watchlist exporting within Microsoft Sentinel that I have found, such as:
* Microsoft Azure Sentinel's query can only display about 30,000 results for any queries, per page. (including that of watchlist reading query)
* The "export as" functionality will only export the results that is currently shown in the page.
* Retrieving watchlist items through API isn't available yet. (at the time of making the script) 

Overtime, while doing several security-related researches and working in an SOC, I have managed to amass approx. around 1.8m records of IoCs which was put in the Sentinel Watchlist. Manually exporting the watchlist at this point is no longer a feasible task for me and my colleagues, as we would have spent hours, days, or even weeks to manually query the data, export it, open the next 30,000 results in another page, export it, and so on. 

This is where this custom exporter script comes in the picture. Utilizing Az PowerShell module, it will help automate watchlist extraction and retrieval process.

## Key Features
This script has the following key features:
* Automate the exporting process of Microsoft Azure Sentinel's Watchlist from a specific Subscription ID, Workspace/Resource Group, and Watchlist datasets, using REST method.
* Automatically retrieve data from the next API Link, using a loop condition. (Sentinel creates a unique API link for each of the data pages, and called in a sequential manner, instead of putting the whole data in one API)
* Export the results in a JSON format, that could be easily reformatted and reused in other SOC environment, whether it is using Sentinel or other SIEM platforms.

## Installation & Configurations
To run the script, first we need to install [Azure PowerShell](https://learn.microsoft.com/en-us/powershell/azure/install-azps-windows?view=azps-11.2.0&tabs=powershell&pivots=windows-psgallery) module.
```ps1
# Check Execution Policy
Get-ExecutionPolicy -List

# Azure PowerShell module requires at least RemoteSigned execution policy to be installed and run. 
# Change Execution Policy (if not set to at least RemoteSigned)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Install the Module
Install-Module -Name Az -Repository PSGallery -Force

# Check for Module Updates
Update-Module -Name Az -Force

# Sign in
Connect-AzAccount

# If any configuration changes need to be set, e.g. SubscriptionID
Set-AzContext -<Context Name> "<Context Value>" # Change the value inside <> accordingly.
```

To install the Azure Sentinel Watchlist Exporter script.
```
git clone https://github.com/ge-wijayanto/AZ-Sentinel-WatchlistExporter.git
```

To change the config, open the .ps1 script using preferred choice of text editors (Notepad could simply work just fine.). Then, change the following values in the script:
```ps1
$SubscriptionId = " " # SubscriptionId, found in the Azure Portal
$ResourceGroupName = " " # Resource Group Name with the Workspace containing the Watchlist 
$WorkspaceName = " " # Workspace Name from which the watchlist is going to be extracted 
$WatchlistName = " " # Name of the watchlist to be exported
$ApiVersion = "2022-12-01-preview" # Leave as is
$OutputFilePath = "ExportedWatchlist.json" # Name of the JSON export files
```
More info on how to acquire those values can be found in [here](https://learn.microsoft.com/en-us/azure/azure-portal/get-subscription-tenant-id)

## Usage Guide
```ps1
# Open the PowerShell using administrator privileges

# Run the script
path/to/file/ExportWL.ps1

# Wait until the process is completed.
```

## Result Sample

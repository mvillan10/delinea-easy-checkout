# Delinea secret server ID, Bearer Token, and saveToFile configuration
$secretId = 1234 # Secret ID 
$apiToken = "{API_TOKEN}" # Bearer Token
$saveToFile = $true # Save password to file

# Define the API base URL
$secretServerUrl = "https://maersk-prod.secretservercloud.co.uk"
$baseUrl = "https://maersk-prod.secretservercloud.co.uk/api/v1"
$checkOutUrl = "secrets/$secretId/fields/password"

# Create headers with Authorization
$headers = @{
    "Authorization" = "Bearer ${apiToken}"
    "Content-Type"  = "application/json"
}


# Send the API request and get the response
try {
    # Display the headers
    Write-Output "Headers:"
    $headers.GetEnumerator() | ForEach-Object { Write-Output "$($_.Key): $($_.Value)" }

    Write-Output "Sending request to $secretServerUrl..."

    $apiUrl = "$baseUrl/${checkOutUrl}?autoCheckout=true&autoCheckin=false"
    Write-Output "Request URL: $apiUrl..."

    $response = Invoke-RestMethod -Uri $apiUrl -Method Get -Headers $headers
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    if ($saveToFile) 
    {
        # Define the path to the existing text file
        $outputFile = $PSScriptRoot + "\password.txt"

        # Format the new file content
        $fileContent = "ADM Password: {0}`n`nLast updated: {1}" -f $response, $timestamp

        # Overwrite the file with new content
        $fileContent | Out-File -FilePath $outputFile -Encoding UTF8 -Force

        Write-Output "Saved password to file $outputFile"
    }
    
    # Copy response to clipboard
    $response | Set-Clipboard

    Write-Output "Success: API response saved to file and copied to clipboard."
    Write-Output "You can now paste the password anywhere (Ctrl + V)."
   
} catch {
    $errorMessage = "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") - Error: $_"
    Write-Output $errorMessage
}

# Pause to keep the console open
Write-Output "Press any key to exit..."
[System.Console]::ReadKey() | Out-Null
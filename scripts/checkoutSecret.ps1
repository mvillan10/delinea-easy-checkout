# Load environment variables from .env file
$envFilePath = "$PSScriptRoot\.env"
if (-not (Test-Path $envFilePath)) {
    Write-Output "Error: .env file not found. Please ensure the .env file is present in the script directory."
    exit
}

Get-Content $envFilePath | ForEach-Object {
    if ($_ -match "^\s*([^=]+?)\s*=\s*(.*?)\s*$") {
        [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2])
    }
}

# Delinea secret server ID and saveToFile configuration
$secretId = [System.Environment]::GetEnvironmentVariable("SECRET_ID")
$back4AppUrl = [System.Environment]::GetEnvironmentVariable("BACK4APP_URL")
$appId = [System.Environment]::GetEnvironmentVariable("APP_ID")
$apiKey = [System.Environment]::GetEnvironmentVariable("API_KEY")
$secretServerUrl = [System.Environment]::GetEnvironmentVariable("SECRET_SERVER_URL")
$saveToFile = $true # Save password to file

# Function to fetch the token from Back4App
function Fetch-TokenFromBack4App {
    $headers = @{
        "X-Parse-Application-Id" = $appId
        "X-Parse-REST-API-Key"   = $apiKey
        "Content-Type"           = "application/json"
    }

    try {
        $response = Invoke-RestMethod -Uri $back4AppUrl -Method Post -Headers $headers
        return $response.result
    } catch {
        Write-Output "Error fetching API token from Back4App: $_"
        return $null
    }
}

# Fetch the API token from Back4App
$apiToken = Fetch-TokenFromBack4App
if (-not $apiToken) {
    Write-Output "Error: API token not found. Please ensure the token is available in Back4App."
    exit
}

# Define the API base URL
$baseUrl = "$secretServerUrl/api/v1"
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

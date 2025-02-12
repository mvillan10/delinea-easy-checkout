# Define the API endpoint and request parameters
$apiUrl = "https://maersk-prod.secretservercloud.co.uk/api/v1/api-token/generate-token/"
$tokenFilePath = "$PSScriptRoot\apiToken.txt"
$logFilePath = "$PSScriptRoot\fetchApiToken.log"
$expiryTimeInSeconds = 3000 # 50 minutes

# Function to log messages to a file with a timestamp
function Log-Message {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"
    $logMessage | Out-File -FilePath $logFilePath -Append -Encoding UTF8
    Write-Output $logMessage
}

# Function to fetch the API token
function Get-ApiToken {
    $headers = @{"Authorization" = "Bearer $bearerToken"}

    try {
        $response = Invoke-RestMethod -Uri $apiUrl -Method Get -Headers $headers
        return $response.generatedToken.value
    } catch {
        Log-Message "Error fetching API token: $_"
        return $null
    }
}

# Function to read the token from the file
function Read-TokenFromFile {
    if (Test-Path $tokenFilePath) {
        return Get-Content -Path $tokenFilePath -Raw
    }
    return $null
}

# Function to save the token to the file
function Save-TokenToFile($token) {
    $token | Out-File -FilePath $tokenFilePath -Encoding UTF8 -Force
}

# Fetch the API token right away
$bearerToken = Read-TokenFromFile
if ($bearerToken) {
    Log-Message "Using existing API token"
    $bearerToken = Get-ApiToken
    if ($bearerToken) {
        Save-TokenToFile $bearerToken
        Log-Message "Fetched and saved new API token"
    } else {
        Log-Message "Failed to fetch API token."
    }
} else {
    Log-Message "No existing API token found."
}

# Loop to fetch the API token every $expiryTimeInSeconds seconds
while ($true) {
    Start-Sleep -Seconds $expiryTimeInSeconds
    $bearerToken = Get-ApiToken
    if ($bearerToken) {
        Save-TokenToFile $bearerToken
        Log-Message "Fetched and saved new API token"
    } else {
        Log-Message "Failed to fetch API token."
    }
}

# Curl equivalent of the API request
# curl --location 'https://maersk-prod.secretservercloud.co.uk/api/v1/api-token/generate-token/' \
# --header 'Authorization: Bearer AgKrglRXml0Ubw1se9-ClQZjX0OCm7Uu9pbtNiKKUpcc8weURChKwhbnlq8Y6KDLUddRRrN3yKACCWKsWD8WP2SB-4Z8NWSkJdVTC_MmWqoSv5gLDvSx2aqeP-9aS1hGo0usK6Ib99uWZgRx7JxWkQD6EeTLFirVEyKEhaf-knW7tTXtdB37tWIVxp7aY_SZa9FMVeVf04P0JYjQh3WSsiXf1xXaW61R8bxhOApEkhlt1hbnzrhOB7B9PdLoDDxhNDwgkftuVy2UIu2TIJGT-bVqOA3yWEdxqG20hBROg7KEwhbEK_JA_pzEFkHI7BnlWCT6vmfZg-caSc_d6kMzS7spIT5JUkGAYQpSvecZHSWmQ8k5uomLLK9oNwI2rhGUxeRcOfQVY6Pr3N_7sIByMLNLOkFOv0ShbEOgeEk2mgn1wQPJgJfZI6PM8uPar6XDP77No9u-qUOQHOiUo-0xapuIeKjiU_KfMuRhNMeeDMjiXmkLOFrUxLdp_q8m56xPL9-7lWl-BhQLv3ZjGx5ATRoxwowi3OMJyb_690ku3l0XGoYc8AlEexav1fP-KsviY4n_HiY4LA0La_nCWycZC2d4SEdwsI2mxBifc1pe5is5-30RpogZMHp8-aqN3Twj_sOpfwPRJfg0o2p4WneR4XfpwVcNVmQB_o4YAy89cHu8ILFpwNoJkMmJxep_PjMziV3NKNVk4BwNvAoEcZBw5wig'

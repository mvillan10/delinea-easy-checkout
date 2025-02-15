const axios = require('axios');
const fs = require('fs');
const path = require('path');

// API URL to fetch the new token
const apiUrl = "https://maersk-prod.secretservercloud.co.uk/api/v1/api-token/generate-token/";
// File paths to store the token and logs
const tokenFilePath = path.join(__dirname, 'apiToken.txt');
const logFilePath = path.join(__dirname, 'fetchApiToken.log');

// Function to log messages with a timestamp
function logMessage(message) {
    const timestamp = new Date().toISOString();
    const logMessage = `${timestamp} - ${message}\n`;
    fs.appendFileSync(logFilePath, logMessage);
    console.log(logMessage);
}

// Function to fetch the API token using the bearer token
async function getApiToken(bearerToken) {
    try {
        const response = await axios.get(apiUrl, {
            headers: {
                'Authorization': `Bearer ${bearerToken}`
            }
        });
        return response.data.generatedToken.value;
    } catch (error) {
        logMessage(`Error fetching API token: ${error.message}`);
        return null;
    }
}

// Function to read the token from the file
function readTokenFromFile() {
    if (fs.existsSync(tokenFilePath)) {
        return fs.readFileSync(tokenFilePath, 'utf8');
    }
    return null;
}

// Function to save the token to the file
function saveTokenToFile(token) {
    fs.writeFileSync(tokenFilePath, token);
}

// Cloud job to fetch and refresh the API token periodically
Parse.Cloud.job("scheduledFetchApiToken", async (request) => {
    let bearerToken = readTokenFromFile();
    if (bearerToken) {
        logMessage("Using existing API token");
        bearerToken = await getApiToken(bearerToken);
        if (bearerToken) {
            saveTokenToFile(bearerToken);
            logMessage("Fetched and saved new API token");
        } else {
            logMessage("Failed to fetch API token.");
        }
    } else {
        logMessage("No existing API token found.");
    }
});

// Cloud function to get the current API token
Parse.Cloud.define("getApiToken", async (request) => {
    const token = readTokenFromFile();
    if (token) {
        return token;
    } else {
        throw new Error("API token not found.");
    }
});

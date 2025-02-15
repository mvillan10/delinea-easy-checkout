# Delinea Password Generator - Back4App Deployment

This project automates the process of checking out a secret password from Delinea Secret Server and saving it to a file. This readme provides instructions for deploying the project on Back4App.

## Files

- `main.js`: Back4App Cloud Function to fetch and refresh the API token periodically.

## Setup

1. Create a Back4App account and application.
2. In the Back4App dashboard, navigate to your application.

## Usage

### Deploy the Cloud Function

1. In the Back4App dashboard, go to "Cloud Code" and then "Functions".
2. Create a new function and upload your `main.js` file.

### Schedule the Cloud Function

1. In the Back4App dashboard, go to "Cloud Code" and then "Jobs".
2. Click on "Create a new job".
3. Name your job (e.g., `scheduledFetchApiToken`).
4. Select the function you created (`scheduledFetchApiToken`).
5. Set the schedule to run every 50 minutes.

### Verify the Deployment

After scheduling the job, you can verify that it is running correctly by checking the logs in the Back4App dashboard.

## Configuration

- Update the `$apiUrl` and other relevant variables in `main.js` as needed.

## License

This project is licensed under the MIT License.

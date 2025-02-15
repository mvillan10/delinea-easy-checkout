# Delinea Password Generator

This project automates the process of checking out a secret password from Delinea Secret Server and saving it to a file.

## Files

- `scripts/GenerateADMPassword.bat`: Batch script to execute the PowerShell script.
- `scripts/checkoutSecret.ps1`: PowerShell script to fetch the password from Delinea Secret Server.
- `scripts/password.txt`: File where the fetched password is saved.
- `scripts/.env`: Environment variables file.
- `back4app/functions/main.js`: Back4App Cloud Function to fetch and refresh the API token periodically.
- `back4app/readme.md`: Instructions for deploying the project on Back4App.

## Setup

1. Ensure you have PowerShell installed on your system.
2. Clone this repository to your local machine.
3. Create a `.env` file in the `scripts` directory and populate it with your environment variables. You can use `scripts/example.env` as a template.

## Usage

1. Open a command prompt.
2. Navigate to the project directory.
3. Run the batch script:
    ```sh
    scripts\GenerateADMPassword.bat
    ```
4. The password will be saved to `scripts/password.txt` and copied to your clipboard.

## Configuration

- Update the environment variables in the `scripts/.env` file with your Delinea Secret Server ID, Back4App URL, App ID, API Key, and Secret Server URL.

## License

This project is licensed under the MIT License.

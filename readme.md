# Delinea Password Generator

This project automates the process of checking out a secret password from Delinea Secret Server and saving it to a file.

## Files

- `GenerateADMPassword.bat`: Batch script to execute the PowerShell script.
- `checkoutSecret.ps1`: PowerShell script to fetch the password from Delinea Secret Server.
- `password.txt`: File where the fetched password is saved.

## Setup

1. Ensure you have PowerShell installed on your system.
2. Clone this repository to your local machine.

## Usage

1. Open a command prompt.
2. Navigate to the project directory.
3. Run the batch script:
    ```sh
    GenerateADMPassword.bat
    ```
4. The password will be saved to `password.txt` and copied to your clipboard.

## Configuration

- Update the `$secretId` and `$apiToken` variables in `checkoutSecret.ps1` with your Delinea Secret Server ID and API token.

## License

This project is licensed under the MIT License.

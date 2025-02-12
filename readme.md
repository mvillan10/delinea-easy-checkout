# Delinea Password Generator

This project automates the process of checking out a secret password from Delinea Secret Server and saving it to a file.

## Files

- `GenerateADMPassword.bat`: Batch script to execute the PowerShell script.
- `checkoutSecret.ps1`: PowerShell script to fetch the password from Delinea Secret Server.
- `password.txt`: File where the fetched password is saved.
- `fetchApiToken.ps1`: PowerShell script to fetch and refresh the API token periodically.
- `RunFetchApiTokenService.bat`: Batch script to run `fetchApiToken.ps1` as a service.
- `CreateScheduledTask.ps1`: PowerShell script to create a scheduled task for running `RunFetchApiTokenService.bat`.

## Setup

1. Ensure you have PowerShell installed on your system.
2. Clone this repository to your local machine.

## Usage

1. Open a command prompt.
2. Navigate to the project directory.
3. Run the batch script to generate the ADM password:
    ```sh
    GenerateADMPassword.bat
    ```
4. The password will be saved to `password.txt` and copied to your clipboard.
5. To set up the API token fetcher as a background service, run the following PowerShell script:
    ```sh
    .\CreateScheduledTask.ps1
    ```

## Configuration

- Update the `$secretId` and `$apiToken` variables in `checkoutSecret.ps1` with your Delinea Secret Server ID and API token.
- Update the `$apiUrl` and other relevant variables in `fetchApiToken.ps1` as needed.

## License

This project is licensed under the MIT License.

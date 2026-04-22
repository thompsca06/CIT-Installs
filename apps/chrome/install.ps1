$ErrorActionPreference = "Stop"

$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
if (Test-Path $chromePath) {
    Write-Log "Chrome already installed - skipping"
    return
}

$installer = "$env:TEMP\chrome.msi"
Invoke-Download -Uri "https://dl.google.com/chrome/install/googlechromestandaloneenterprise64.msi" -OutFile $installer
Install-MSI -Path $installer
Write-Log "Chrome installed successfully"

$ErrorActionPreference = "Stop"

$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"

if (Test-Path $chromePath) {
    Write-Host "Chrome already installed – skipping"
    return
}

$installer = "$env:TEMP\chrome.msi"

Invoke-WebRequest `
    -Uri "https://dl.google.com/chrome/install/googlechromestandaloneenterprise64.msi" `
    -OutFile $installer

Start-Process msiexec.exe `
    -ArgumentList "/i `"$installer`" /qn /norestart" `
    -Wait

Write-Host "Chrome installed successfully"

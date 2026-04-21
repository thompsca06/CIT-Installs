$ErrorActionPreference = "Stop"

if (Test-RegistryInstall -DisplayName "7-Zip") {
    Write-Log "7-Zip already installed - skipping"
    return
}

Write-Log "Resolving latest 7-Zip version..."
$downloadPage = Invoke-WebRequest -Uri "https://www.7-zip.org/download.html" -UseBasicParsing
$msiPath = ($downloadPage.Links.href | Where-Object { $_ -match "7z\d+-x64\.msi$" } | Select-Object -First 1)
if (-not $msiPath) { throw "Could not find 7-Zip MSI download link on 7-zip.org" }
$uri = "https://www.7-zip.org/$msiPath"
Write-Log "Found 7-Zip installer: $uri"

$installer = "$env:TEMP\7zip.msi"
Invoke-Download -Uri $uri -OutFile $installer
Install-MSI -Path $installer
Write-Log "7-Zip installed successfully"

$ErrorActionPreference = "Stop"

if (Test-RegistryInstall -DisplayName "7-Zip") {
    Write-Log "7-Zip already installed - skipping"
    return
}

Write-Log "Resolving latest 7-Zip version..."
$release = Invoke-RestMethod -Uri "https://api.github.com/repos/ip7z/7zip/releases/latest" -UseBasicParsing
$asset = $release.assets | Where-Object { $_.name -match "7z\d+-x64\.msi$" } | Select-Object -First 1
if (-not $asset) { throw "Could not find 7-Zip x64 MSI in latest GitHub release" }
$uri = $asset.browser_download_url
Write-Log "Found 7-Zip installer: $uri"

$installer = "$env:TEMP\7zip.msi"
Invoke-Download -Uri $uri -OutFile $installer
Install-MSI -Path $installer
Write-Log "7-Zip installed successfully"

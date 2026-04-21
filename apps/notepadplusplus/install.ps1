$ErrorActionPreference = "Stop"

if (Test-RegistryInstall -DisplayName "Notepad++") {
    Write-Log "Notepad++ already installed - skipping"
    return
}

Write-Log "Resolving latest Notepad++ version..."
$release = Invoke-RestMethod -Uri "https://api.github.com/repos/notepad-plus-plus/notepad-plus-plus/releases/latest" -UseBasicParsing
$asset = $release.assets | Where-Object { $_.name -match "Installer\.x64\.exe$" } | Select-Object -First 1
if (-not $asset) { throw "Could not find Notepad++ x64 installer in latest GitHub release" }
$uri = $asset.browser_download_url
Write-Log "Found Notepad++ installer: $uri"

$installer = "$env:TEMP\npp-installer.exe"
Invoke-Download -Uri $uri -OutFile $installer
Install-EXE -Path $installer -Arguments "/S"
Write-Log "Notepad++ installed successfully"

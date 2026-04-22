#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"

# Azure Image Builder runs only this file — everything else must be pulled down first.
$RepoBase   = "https://raw.githubusercontent.com/thompsca06/CIT-Installs/main"
$StagingDir = "C:\ImageBuild\Scripts"
$LogDir     = "C:\ImageBuild\Logs"

New-Item -ItemType Directory -Path $StagingDir, $LogDir -Force | Out-Null
Start-Transcript -Path "$LogDir\build-image.log" -Append

# Force TLS 1.2 — required for GitHub raw and most vendor download CDNs
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Get-RepoFile {
    param (
        [string]$RelativePath   # e.g. "common/logging.ps1"
    )
    $localPath = Join-Path $StagingDir ($RelativePath -replace "/", "\")
    $localDir  = Split-Path $localPath -Parent
    New-Item -ItemType Directory -Path $localDir -Force | Out-Null
    Invoke-WebRequest -Uri "$RepoBase/$RelativePath" -OutFile $localPath -UseBasicParsing
    return $localPath
}

# Pull down and load shared modules before anything else
. (Get-RepoFile "common/logging.ps1")
. (Get-RepoFile "common/helpers.ps1")

Write-Log "Staging directory: $StagingDir"
Write-Log "Starting image build"

# Pull down app list and load it to populate $AppsToInstall
. (Get-RepoFile "config/app-list.ps1")

foreach ($app in $AppsToInstall) {
    Write-Log "Installing: $app"
    $scriptPath = Get-RepoFile "apps/$app/install.ps1"
    & $scriptPath
}

Write-Log "Image build completed successfully"
Stop-Transcript

# Fail fast
$ErrorActionPreference = "Stop"

# Paths
$BasePath = "C:\ImageBuild"
$LogPath  = "$BasePath\Logs"

New-Item -ItemType Directory -Path $BasePath -Force | Out-Null
New-Item -ItemType Directory -Path $LogPath  -Force | Out-Null

Start-Transcript -Path "$LogPath\build-image.log" -Append

Write-Host "Starting Image Builder bootstrap script"

# Import helpers
. "$PSScriptRoot\..\common\logging.ps1"
. "$PSScriptRoot\..\common\helpers.ps1"

# Load app list
$appListPath = "$PSScriptRoot\..\config\app-list.ps1"

if (-not (Test-Path $appListPath)) {
    throw "App list not found at $appListPath"
}

. $appListPath

foreach ($app in $AppsToInstall) {
    Write-Log "Installing application: $app"

    $scriptPath = "$PSScriptRoot\..\apps\$app\install.ps1"

    if (-not (Test-Path $scriptPath)) {
        throw "Install script not found for app [$app]"
    }

    & $scriptPath
}

Write-Log "Image build completed successfully"

Stop-Transcript

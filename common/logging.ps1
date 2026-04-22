function Write-Log {
    param (
        [string]$Message,
        [ValidateSet("INFO", "WARN", "ERROR")]
        [string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$timestamp] [$Level] $Message"

    if ($Level -eq "ERROR") {
        # Write to stdout (captured by transcript) and stderr (captured by Packer separately)
        Write-Host $line
        [Console]::Error.WriteLine($line)
    } else {
        Write-Host $line
    }
}

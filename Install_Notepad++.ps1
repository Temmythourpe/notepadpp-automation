# ========== CONFIGURATION ==========
$NppExePath = "C:\Program Files\Notepad++\notepad++.exe"
$InstallerBaseURL = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download"
$InstallerPath = "$env:TEMP\npp_installer.exe"

# ========== FUNCTIONS ==========

function Get-InstalledNppVersion {
    if (Test-Path $NppExePath) {
        try {
            return [version](Get-Item $NppExePath).VersionInfo.ProductVersion
        }
        catch {
            return $null
        }
    }
    return $null
}

function Get-LatestNppVersion {
    try {
        $latest = Invoke-RestMethod -Uri "https://api.github.com/repos/notepad-plus-plus/notepad-plus-plus/releases/latest" -Headers @{ "User-Agent" = "PowerShell" }
        return $latest.tag_name.TrimStart("v")
    }
    catch {
        Write-Host "Failed to retrieve latest version info from GitHub."
        return $null
    }
}

# ========== MAIN ==========

Write-Host "`n Checking current Notepad++ installation..."
$CurrentVersion = Get-InstalledNppVersion
Write-Host "Installed version: $($CurrentVersion -join '')"

$LatestVersion = Get-LatestNppVersion
if (-not $LatestVersion) { exit 1 }
Write-Host "Latest available version: $LatestVersion"

# Compare versions
if ($CurrentVersion -and ([version]$CurrentVersion -ge [version]$LatestVersion)) {
    Write-Host "Notepad++ is up to date."
    exit 0
}

Write-Host "Updating Notepad++ to version $LatestVersion..."

# Construct the latest installer URL (64-bit)
$InstallerURL = "$InstallerBaseURL/v$LatestVersion/npp.$LatestVersion.Installer.x64.exe"

# Download installer
try {
    Invoke-WebRequest -Uri $InstallerURL -OutFile $InstallerPath -UseBasicParsing
    Write-Host "Installer downloaded."
}
catch {
    Write-Host "Failed to download installer: $_"
    exit 1
}

# Install silently
try {
    Start-Process -FilePath $InstallerPath -ArgumentList "/S" -Wait -NoNewWindow
    Start-Sleep -Seconds 3
}
catch {
    Write-Host "Silent install failed: $_"
    exit 1
}

# Confirm installation
$InstalledVersion = Get-InstalledNppVersion
if ($InstalledVersion -and $InstalledVersion -eq [version]$LatestVersion) {
    Write-Host "Notepad++ updated successfully to version $InstalledVersion"
}
else {
    Write-Host "Update attempted, but version mismatch: $InstalledVersion"
}

# Clean up
Remove-Item $InstallerPath -Force -ErrorAction SilentlyContinue

############# Uninstall Notepad++ #############
function Get-UninstallString {
    param([string]$DisplayName)

    $paths = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )

    foreach ($path in $paths) {
        $keys = Get-ItemProperty -Path $path -ErrorAction SilentlyContinue
        foreach ($key in $keys) {
            if ($key.DisplayName -like "*$DisplayName*") {
                return $key.UninstallString
            }
        }
    }
    return $null
}

function IsNotepadPPInstalled {
    $found = $false
    $paths = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )
    foreach ($path in $paths) {
        $keys = Get-ItemProperty -Path $path -ErrorAction SilentlyContinue
        foreach ($key in $keys) {
            if ($key.DisplayName -like "*Notepad++*") {
                $found = $true
                break
            }
        }
        if ($found) { break }
    }
    return $found
}

# Get uninstall string
$uninstallString = Get-UninstallString -DisplayName "Notepad++"

if (-not $uninstallString) {
    Write-Host "Notepad++ uninstall string not found. Notepad++ may not be installed."
    exit 1
}

# Parse uninstall executable and arguments
if ($uninstallString -match '\"(.+?\.exe)\"') {
    $uninstallExe = $matches[1]
    $arguments = $uninstallString.Replace("`"$uninstallExe`"", "").Trim()
}
elseif ($uninstallString -match '(.+?\.exe)') {
    $uninstallExe = $matches[1]
    $arguments = $uninstallString.Replace($uninstallExe, "").Trim()
}
else {
    $uninstallExe = $uninstallString
    $arguments = ""
}

# Add silent uninstall switch
if ($uninstallExe -like "*.msi") {
    $silentArgs = "/quiet /norestart"
}
else {
    $silentArgs = "/S"
}

$finalArgs = "$arguments $silentArgs"

# Run uninstall silently
Start-Process -FilePath $uninstallExe -ArgumentList $finalArgs -Wait -WindowStyle Hidden

# Wait a bit to allow uninstall to complete fully
Start-Sleep -Seconds 5

# Check if still installed
if (-not (IsNotepadPPInstalled)) {
    Write-Host "Notepad++ was uninstalled successfully."
    exit 0
}
else {
    Write-Host "Notepad++ uninstall failed or still present."
    exit 1
}

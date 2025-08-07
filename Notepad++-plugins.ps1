############## Notepad++ Plugins Installation for AutoSave & Java ##############

# Enable TLS 1.2 for HTTPS downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$pluginsDir = "C:\Program Files\Notepad++\plugins"

# -------- Install AutoSave Plugin --------
$autoSaveUrl = "https://github.com/francostellari/NppPlugins/raw/refs/heads/main/AutoSave/AutoSave_dll_2v00_x64.zip"
$autoSaveZip = "$env:TEMP\AutoSave.zip"
$autoSaveFolder = Join-Path $pluginsDir "AutoSave"

Write-Host "Installing AutoSave plugin..."

try {
    Invoke-WebRequest -Uri $autoSaveUrl -OutFile $autoSaveZip -UseBasicParsing -Headers @{ "User-Agent" = "Mozilla/5.0" }
    if (-not (Test-Path $autoSaveFolder)) {
        New-Item -ItemType Directory -Path $autoSaveFolder -Force | Out-Null
    }
    Expand-Archive -Path $autoSaveZip -DestinationPath $autoSaveFolder -Force
    Remove-Item $autoSaveZip -Force
    Write-Host "AutoSave plugin installed to $autoSaveFolder"
}
catch {
    Write-Host "Failed to install AutoSave plugin: $_"
}

# -------- Install Java Plugin --------
Write-Host "Installing Java plugin..."

try {
    $apiUrl = "https://api.github.com/repos/dominikcebula/npp-java-plugin/releases/latest"
    $headers = @{ "User-Agent" = "Mozilla/5.0" }
    $release = Invoke-RestMethod -Uri $apiUrl -Headers $headers

    # Find asset ending with .zip
    $javaPluginAsset = $release.assets | Where-Object { $_.name -like "*.zip" } | Select-Object -First 1

    if (-not $javaPluginAsset) {
        throw "Could not find ZIP asset in the latest release."
    }

    $javaPluginUrl = $javaPluginAsset.browser_download_url
    $javaPluginZip = "$env:TEMP\JavaPlugin.zip"
    $javaPluginFolder = Join-Path $pluginsDir "Java"

    # Download the Java plugin ZIP
    Invoke-WebRequest -Uri $javaPluginUrl -OutFile $javaPluginZip -Headers $headers -UseBasicParsing

    if (-not (Test-Path $javaPluginFolder)) {
        New-Item -ItemType Directory -Path $javaPluginFolder -Force | Out-Null
    }

    # Extract
    Expand-Archive -Path $javaPluginZip -DestinationPath $javaPluginFolder -Force
    Remove-Item $javaPluginZip -Force

    Write-Host "Java plugin installed to $javaPluginFolder"
}
catch {
    Write-Host "Failed to install Java plugin: $_"
}

Write-Host "Plugin installation complete. Please restart Notepad++ to activate the plugins."

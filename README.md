# Notepad++ Automation Scripts

This project contains PowerShell scripts for silently automating the installation, plugin setup, and uninstallation of Notepad++.

## Scripts

# NotepadPP-Install.ps1
Silently installs the latest version of Notepad++.

# NotepadPP-Plugins.ps1
Installs the following Notepad++ plugins silently:
- [AutoSave](https://github.com/francostellari/NppPlugins/tree/main/AutoSave)
- [Java Plugin](https://github.com/dominikcebula/npp-java-plugin)

# NotepadPP-Uninstall.ps1
Silently uninstalls Notepad++ and checks for successful removal.

# Requirements
- Run PowerShell as Administrator
- Internet connection (for downloading installers and plugins)
- Windows OS

# Notes
- Ensure Notepad++ is closed before running the plugin or uninstall scripts
- Scripts are designed for enterprise environments or lab testing

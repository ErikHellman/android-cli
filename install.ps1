#Requires -Version 5.1
$ErrorActionPreference = "Stop"

$Repo    = "ErikHellman/android-cli"
$Binary  = "acli"
$Asset   = "${Binary}-windows-amd64.exe"
$Url     = "https://github.com/${Repo}/releases/latest/download/${Asset}"

# Install to a user-local directory — no administrator rights required
$InstallDir = "$env:LOCALAPPDATA\Programs\acli"
$Dest       = "$InstallDir\${Binary}.exe"

New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

Write-Host "Downloading $Asset..."
Invoke-WebRequest -Uri $Url -OutFile $Dest -UseBasicParsing
Write-Host "Installed acli to $Dest"

# Add install directory to the user PATH if not already present
$UserPath = [Environment]::GetEnvironmentVariable("PATH", "User") ?? ""
if ($UserPath -notlike "*$InstallDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$UserPath;$InstallDir", "User")
    Write-Host "Added $InstallDir to your PATH."
    Write-Host "Restart your terminal for the change to take effect."
}

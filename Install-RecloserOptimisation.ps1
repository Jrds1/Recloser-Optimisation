Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

$PackageRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$InstallRoot = Join-Path $env:LOCALAPPDATA "RecloserOptimisation"
$Desktop = [Environment]::GetFolderPath("Desktop")
$ShortcutPath = Join-Path $Desktop "Recloser Optimisation.lnk"

$RequiredFiles = @(
  "RecloserOptimisationApp.ps1",
  "Start-RecloserOptimisationApp.cmd",
  "README.md",
  "config\import-adapters.json",
  "config\prototype-accounts.json",
  "assets\icon.ico",
  "assets\logo.jpg"
)

foreach ($relativePath in $RequiredFiles) {
  $source = Join-Path $PackageRoot $relativePath
  if (-not (Test-Path -LiteralPath $source)) {
    throw "Missing required package file: $relativePath"
  }
}

if (-not (Test-Path -LiteralPath $InstallRoot)) {
  New-Item -ItemType Directory -Path $InstallRoot | Out-Null
}

$configRoot = Join-Path $InstallRoot "config"
if (-not (Test-Path -LiteralPath $configRoot)) {
  New-Item -ItemType Directory -Path $configRoot | Out-Null
}

$assetRoot = Join-Path $InstallRoot "assets"
if (-not (Test-Path -LiteralPath $assetRoot)) {
  New-Item -ItemType Directory -Path $assetRoot | Out-Null
}

Copy-Item -LiteralPath (Join-Path $PackageRoot "RecloserOptimisationApp.ps1") -Destination $InstallRoot -Force
Copy-Item -LiteralPath (Join-Path $PackageRoot "Start-RecloserOptimisationApp.cmd") -Destination $InstallRoot -Force
Copy-Item -LiteralPath (Join-Path $PackageRoot "README.md") -Destination $InstallRoot -Force
Copy-Item -LiteralPath (Join-Path $PackageRoot "config\import-adapters.json") -Destination $configRoot -Force
Copy-Item -LiteralPath (Join-Path $PackageRoot "config\prototype-accounts.json") -Destination $configRoot -Force
Copy-Item -LiteralPath (Join-Path $PackageRoot "assets\icon.ico") -Destination $assetRoot -Force
Copy-Item -LiteralPath (Join-Path $PackageRoot "assets\logo.jpg") -Destination $assetRoot -Force

$target = Join-Path $InstallRoot "Start-RecloserOptimisationApp.cmd"
$icon = Join-Path $assetRoot "icon.ico"
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($ShortcutPath)
$shortcut.TargetPath = $target
$shortcut.WorkingDirectory = $InstallRoot
$shortcut.Description = "Launch the Recloser Optimisation desktop prototype"
$shortcut.IconLocation = $icon
$shortcut.Save()

Write-Host ""
Write-Host "Recloser Optimisation installed for this Windows user." -ForegroundColor Green
Write-Host "Installed to: $InstallRoot"
Write-Host "Desktop shortcut: $ShortcutPath"
Write-Host ""
Write-Host "You can now launch it from the Desktop shortcut."

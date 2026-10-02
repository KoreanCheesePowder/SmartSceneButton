$ErrorActionPreference = "Stop"
Set-Location -LiteralPath $PSScriptRoot

try {
  if (-not (Get-Command smartthings -ErrorAction SilentlyContinue)) {
    throw "SmartThings CLI was not found. Use the PC where the original driver was installed."
  }
  foreach ($relativePath in @("config.yml", "src\init.lua", "profiles\cp-wheel-button.yml", "fingerprints.yml")) {
    if (-not (Test-Path -LiteralPath (Join-Path $PSScriptRoot $relativePath) -PathType Leaf)) {
      throw "Missing file: $relativePath. Extract the complete ZIP before running this updater."
    }
  }

  Write-Host "C.P WheelButton v1.0.1 - existing driver update" -ForegroundColor Cyan
  Write-Host "No capability creation, presentation changes, device deletion, or re-pairing."
  Write-Host "Use the same account, channel, and hub as the original installation."
  Write-Host "Package key: cheesepowder.zigbee-tuya-button-knob"
  Write-Host ""

  & smartthings edge:drivers:package "." --install
  if ($LASTEXITCODE -ne 0) {
    throw "SmartThings package/install command failed (exit code $LASTEXITCODE)."
  }

  Write-Host ""
  Write-Host "Package/install command completed." -ForegroundColor Green
  Write-Host "Verify v1.0.1 in Driver Information or logcat, then test a single press."
  Write-Host "Keep the existing wheel device and its routines. Do not delete or re-pair it."
  exit 0
} catch {
  Write-Host ""
  Write-Host ("Update failed: " + $_.Exception.Message) -ForegroundColor Red
  exit 1
}

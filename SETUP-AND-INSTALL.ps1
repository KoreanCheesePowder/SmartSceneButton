$ErrorActionPreference = "Stop"
Set-Location -LiteralPath $PSScriptRoot

function Invoke-SmartThings {
  param([Parameter(Mandatory = $true)][string[]]$Arguments)
  & smartthings @Arguments
  if ($LASTEXITCODE -ne 0) {
    throw "SmartThings CLI command failed: smartthings $($Arguments -join ' ')"
  }
}

if (-not (Get-Command smartthings -ErrorAction SilentlyContinue)) {
  throw "SmartThings CLI was not found. Install it or add it to PATH, then run this installer again."
}

Write-Host "[1/4] Checking Wheel Action capability" -ForegroundColor Cyan
$listFile = Join-Path $PSScriptRoot "custom-capability\capabilities-list.json"
if (Test-Path $listFile) { Remove-Item $listFile -Force }
Invoke-SmartThings -Arguments @("capabilities", "-o", $listFile)
$caps = Get-Content $listFile -Raw -Encoding UTF8 | ConvertFrom-Json
$existing = @($caps) | Where-Object {
  $_.id -match '\.wheelAction$' -or $_.name -eq 'Wheel Action'
} | Select-Object -First 1

if ($existing) {
  $wheelCapabilityId = $existing.id
  Write-Host "Using existing capability: $wheelCapabilityId" -ForegroundColor Green
} else {
  Write-Host "Creating Wheel Action capability" -ForegroundColor Yellow
  $createdFile = Join-Path $PSScriptRoot "custom-capability\created-wheel-action.json"
  if (Test-Path $createdFile) { Remove-Item $createdFile -Force }
  Invoke-SmartThings -Arguments @("capabilities:create", "-i", "custom-capability\wheel-action-capability.json", "-o", $createdFile)
  $wheelCapabilityId = (Get-Content $createdFile -Raw -Encoding UTF8 | ConvertFrom-Json).id
}

if (-not $wheelCapabilityId) {
  throw "Unable to determine the Wheel Action capability ID."
}

Write-Host "[2/4] Applying capability presentation" -ForegroundColor Cyan
& smartthings capabilities:presentation:create $wheelCapabilityId -i "custom-capability\wheel-action-presentation.json"
if ($LASTEXITCODE -ne 0) {
  Write-Host "Presentation already exists. Updating it." -ForegroundColor Yellow
  Invoke-SmartThings -Arguments @("capabilities:presentation:update", $wheelCapabilityId, "-i", "custom-capability\wheel-action-presentation.json")
}

Write-Host "[3/4] Generating driver files" -ForegroundColor Cyan
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$profileTemplate = Get-Content "templates\cp-wheel-button.yml.template" -Raw -Encoding UTF8
$profile = $profileTemplate.Replace("__WHEEL_CAPABILITY_ID__", $wheelCapabilityId)
[System.IO.Directory]::CreateDirectory((Join-Path $PSScriptRoot "profiles")) | Out-Null
[System.IO.File]::WriteAllText((Join-Path $PSScriptRoot "profiles\cp-wheel-button.yml"), $profile, $utf8NoBom)

$luaTemplate = Get-Content "templates\init.lua.template" -Raw -Encoding UTF8
$lua = $luaTemplate.Replace("__WHEEL_CAPABILITY_ID__", $wheelCapabilityId)
[System.IO.Directory]::CreateDirectory((Join-Path $PSScriptRoot "src")) | Out-Null
[System.IO.File]::WriteAllText((Join-Path $PSScriptRoot "src\init.lua"), $lua, $utf8NoBom)

Write-Host "[4/4] Packaging and installing driver" -ForegroundColor Cyan
Invoke-SmartThings -Arguments @("edge:drivers:package", ".", "--install")

Write-Host "" 
Write-Host "Installation completed: C.P WheelButton v1.0.1" -ForegroundColor Green
Write-Host "Author: CheesePowder" -ForegroundColor DarkGray
Write-Host "Version: v1.0.1" -ForegroundColor DarkGray
Write-Host "Open SmartThings, select the wheel button, and change its driver to C.P WheelButton." -ForegroundColor Yellow

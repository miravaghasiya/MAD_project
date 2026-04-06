# P2P Marketplace - Mobile Only Run Script (PowerShell)
# Quick script to start just the Flutter mobile app

$ErrorActionPreference = "Stop"

Write-Host "Starting P2P Marketplace Flutter Mobile App..." -ForegroundColor Cyan
Write-Host ""

$mobileDir = "d:\D24IT158\mobile"

# Check for devices
Write-Host "Checking for connected devices..." -ForegroundColor Yellow
$devices = flutter devices
if ($devices -match "No devices detected") {
  Write-Host "ERROR: No Android emulator or device connected" -ForegroundColor Red
  Write-Host ""
  Write-Host "Start an Android emulator with:" -ForegroundColor Cyan
  Write-Host "  emulator -avd <avd_name>" -ForegroundColor Gray
  Write-Host ""
  Write-Host "Or list available AVDs:" -ForegroundColor Cyan
  Write-Host "  emulator -list-avds" -ForegroundColor Gray
  exit 1
}

Write-Host "✓ Available devices:" -ForegroundColor Green
flutter devices | Select-String "device"
Write-Host ""

# Get Flutter deps
Set-Location $mobileDir
Write-Host "Ensuring Flutter dependencies are installed..." -ForegroundColor Yellow
flutter pub get | Out-Null

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Flutter Mobile App Starting..." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "Backend URL: http://10.0.2.2:4000 (Android emulator)" -ForegroundColor Cyan
Write-Host ""

flutter run

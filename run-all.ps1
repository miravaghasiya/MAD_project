# P2P Marketplace - Full Project Run Script (PowerShell)
# Runs backend server and Flutter mobile app in parallel

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "P2P Marketplace - Full Project Setup & Run" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check prerequisites
Write-Host "[1/5] Checking prerequisites..." -ForegroundColor Yellow
$nodeCheck = node --version 2>$null
$npmCheck = npm --version 2>$null
$flutterCheck = flutter --version 2>$null

if (-not $nodeCheck) {
  Write-Host "ERROR: Node.js not found. Please install Node.js from https://nodejs.org/" -ForegroundColor Red
  exit 1
}
if (-not $npmCheck) {
  Write-Host "ERROR: npm not found. Please install npm." -ForegroundColor Red
  exit 1
}
if (-not $flutterCheck) {
  Write-Host "ERROR: Flutter not found. Please install Flutter from https://flutter.dev/" -ForegroundColor Red
  exit 1
}

Write-Host "✓ Node.js $nodeCheck" -ForegroundColor Green
Write-Host "✓ npm $npmCheck" -ForegroundColor Green
Write-Host "✓ Flutter $flutterCheck" -ForegroundColor Green
Write-Host ""

# Setup backend
Write-Host "[2/5] Setting up backend server..." -ForegroundColor Yellow
$serverDir = "d:\D24IT158\server"
if (-not (Test-Path "$serverDir\.env")) {
  Write-Host "ERROR: $serverDir\.env not found. Copy .env.example to .env and configure it." -ForegroundColor Red
  exit 1
}

Write-Host "Checking Firebase service account..." -ForegroundColor Cyan
$firebasePath = (Get-Content "$serverDir\.env" | Select-String "FIREBASE_SERVICE_ACCOUNT" | ForEach-Object { $_ -replace ".*=", "" }).Trim()
if (-not (Test-Path "$serverDir\$firebasePath")) {
  Write-Host "WARNING: Firebase service account file not found at $serverDir\$firebasePath" -ForegroundColor Yellow
  Write-Host "Download from Firebase Console and place the file there." -ForegroundColor Yellow
}

Write-Host "Installing backend dependencies..." -ForegroundColor Cyan
Set-Location $serverDir
if (-not (Test-Path "node_modules")) {
  npm install
  if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: npm install failed" -ForegroundColor Red
    exit 1
  }
}
Write-Host "✓ Backend dependencies ready" -ForegroundColor Green
Write-Host ""

# Setup Flutter
Write-Host "[3/5] Setting up Flutter mobile app..." -ForegroundColor Yellow
$mobileDir = "d:\D24IT158\mobile"
Set-Location $mobileDir
Write-Host "Running flutter pub get..." -ForegroundColor Cyan
flutter pub get | Out-Null
if ($LASTEXITCODE -ne 0) {
  Write-Host "ERROR: flutter pub get failed" -ForegroundColor Red
  exit 1
}
Write-Host "✓ Flutter dependencies ready" -ForegroundColor Green
Write-Host ""

# Check for Firebase config files
Write-Host "[4/5] Checking Flutter Firebase config..." -ForegroundColor Yellow
$androidConfig = "$mobileDir\android\app\google-services.json"
$iosConfig = "$mobileDir\ios\Runner\GoogleService-Info.plist"

if (-not (Test-Path $androidConfig)) {
  Write-Host "WARNING: Android Firebase config not found at $androidConfig" -ForegroundColor Yellow
  Write-Host "Download from Firebase Console (Android app) and place it there." -ForegroundColor Yellow
}
if (-not (Test-Path $iosConfig)) {
  Write-Host "WARNING: iOS Firebase config not found at $iosConfig" -ForegroundColor Yellow
  Write-Host "Download from Firebase Console (iOS app) and place it there." -ForegroundColor Yellow
}
Write-Host ""

# Check for emulator/device
Write-Host "[5/5] Checking connected devices..." -ForegroundColor Yellow
$devices = flutter devices
if ($devices -match "No devices detected") {
  Write-Host "WARNING: No Android emulator or device detected." -ForegroundColor Yellow
  Write-Host "Start an Android emulator or connect a device, then retry." -ForegroundColor Yellow
  Write-Host ""
  Write-Host "To start Android emulator:" -ForegroundColor Cyan
  Write-Host "  emulator -avd <avd_name>" -ForegroundColor Gray
  Write-Host ""
  Write-Host "To list available AVDs:" -ForegroundColor Cyan
  Write-Host "  emulator -list-avds" -ForegroundColor Gray
  exit 1
}
Write-Host "✓ Devices found:" -ForegroundColor Green
flutter devices | Select-String "device"
Write-Host ""

# Start backend
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting Backend Server..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Set-Location $serverDir
Write-Host "Backend will start on http://localhost:4000" -ForegroundColor Cyan
Write-Host ""

# Open backend in new terminal window
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$serverDir'; npm run dev"
Start-Sleep -Seconds 3

# Start mobile
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting Flutter Mobile App..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Set-Location $mobileDir
Write-Host "Flutter will connect to http://10.0.2.2:4000 (for Android emulator)" -ForegroundColor Cyan
Write-Host "For physical device, update api_provider.dart with your machine IP" -ForegroundColor Yellow
Write-Host ""

flutter run

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Project Running!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "Backend: http://localhost:4000" -ForegroundColor Cyan
Write-Host "Mobile: Connected via Flutter" -ForegroundColor Cyan

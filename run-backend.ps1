# P2P Marketplace - Backend Only Run Script (PowerShell)
# Quick script to start just the Node.js Express server

$ErrorActionPreference = "Stop"

Write-Host "Starting P2P Marketplace Backend Server..." -ForegroundColor Cyan
Write-Host ""

$serverDir = "d:\D24IT158\server"

# Check env file
if (-not (Test-Path "$serverDir\.env")) {
  Write-Host "ERROR: .env file not found in server directory" -ForegroundColor Red
  Write-Host "Copy .env.example to .env and fill in your configuration" -ForegroundColor Yellow
  exit 1
}

# Check Firebase service account
$envContent = Get-Content "$serverDir\.env"
$firebasePath = ($envContent | Select-String "FIREBASE_SERVICE_ACCOUNT" | ForEach-Object { $_ -replace ".*=", "" }).Trim()

if (-not (Test-Path "$serverDir\$firebasePath")) {
  Write-Host "WARNING: Firebase service account file not found" -ForegroundColor Yellow
  Write-Host "Path: $serverDir\$firebasePath" -ForegroundColor Yellow
  Write-Host "Download from Firebase Console and place the file there" -ForegroundColor Yellow
  Write-Host ""
}

# Install deps if needed
Set-Location $serverDir
if (-not (Test-Path "node_modules")) {
  Write-Host "Installing dependencies..." -ForegroundColor Yellow
  npm install
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Backend Server Starting..." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "URL: http://localhost:4000" -ForegroundColor Cyan
Write-Host ""

npm run dev

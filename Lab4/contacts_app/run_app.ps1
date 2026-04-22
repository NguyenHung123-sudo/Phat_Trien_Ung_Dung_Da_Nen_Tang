# Script chay app Flutter - Contacts App
Write-Host "=== Khoi dong emulator Pixel 4 ===" -ForegroundColor Cyan

# Khoi dong emulator
$emulatorPath = "$env:LOCALAPPDATA\Android\Sdk\emulator\emulator.exe"
Start-Process -FilePath $emulatorPath -ArgumentList "-avd Pixel_4 -no-snapshot-load"

Write-Host "Dang doi emulator khoi dong (50 giay)..." -ForegroundColor Yellow
Start-Sleep -Seconds 50

# Set Gradle cache sang o D: tranh loi het dia C:
$env:GRADLE_USER_HOME = "D:\.gradle"

Write-Host "=== Chay Flutter app ===" -ForegroundColor Cyan
flutter run -d emulator-5556

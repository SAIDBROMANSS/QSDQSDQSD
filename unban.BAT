@echo off
:: مسح قيمة الحظر من الريجستري بصمت
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\SystemSettings" /v "LicenseStatus" /f >nul 2>&1

:: إغلاق أي عملية معلقة للبرنامج القديم (اختياري)
taskkill /f /im "WindowsFormsApp3.exe" >nul 2>&1

exit
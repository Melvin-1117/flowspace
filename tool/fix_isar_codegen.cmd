@echo off
setlocal

cd /d %~dp0\..
echo Working directory: %cd%

echo.
echo [1/3] Getting packages...
call flutter pub get
if errorlevel 1 goto :fail

echo.
echo [2/3] Generating Isar files...
call dart run build_runner build --delete-conflicting-outputs
if errorlevel 1 goto :fail

echo.
echo [3/3] Done. You can run the app now.
exit /b 0

:fail
echo.
echo Failed. See errors above.
exit /b 1


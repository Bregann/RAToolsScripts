@echo off
title ROM Explorer
cd /d "%~dp0"
rem Find Python (the "py" launcher or python on the PATH)
set PY=
where py >nul 2>nul && set PY=py -3
if not defined PY (where python >nul 2>nul && set PY=python)
if not defined PY (
  echo.
  echo  ROM Explorer needs Python 3.10 or newer, and it isn't installed.
  echo  Opening the download page now. Install it, tick "Add python.exe to PATH",
  echo  then double-click "Start ROM Explorer" again.
  echo.
  start https://www.python.org/downloads/windows/
  pause
  exit /b 1
)
%PY% -c "import sys; sys.exit(0 if sys.version_info >= (3, 10) else 1)"
if errorlevel 1 (
  echo  Your Python is too old. ROM Explorer needs Python 3.10 or newer: https://www.python.org/downloads/windows/
  pause
  exit /b 1
)
echo  Checking ROM Explorer's parts (the first time this downloads a few things)...
%PY% -m pip install -q --disable-pip-version-check -r requirements.txt
if errorlevel 1 echo  Some parts didn't install. ROM Explorer will show what's missing on its Setup page.
echo.
%PY% -m romx
pause

@echo off 
setlocal enableDelayedExpansion 

REM set MYDIR=C:\temp
rem set MYDIR="C:\Program Files (x86)\Jenkins\workspace\python test example\*test.py"

for /F "usebackq delims==" %%x in (`dir /B/D/S *test.py`) do (
  set FILENAME=%%x
  echo !FILENAME!
  set FILENAME="!FILENAME!"
  rem echo %%x
  python -m coverage run !FILENAME!
  rem python -m coverage run !FILENAME!
  python -m coverage xml -o coverage.xml

  REM c:\utils\grep motiv !FILENAME!
)
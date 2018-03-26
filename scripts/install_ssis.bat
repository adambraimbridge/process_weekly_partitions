@echo off
 
REM Get full path to this script without extension
SET scriptname=%~dpn0
 
REM Invoke powershell version of this script
powershell.exe -NonInteractive -ExecutionPolicy Unrestricted -Command %scriptname%.ps1
 
REM return exit code to CodeDeploy
exit /b %ERRORLEVEL%

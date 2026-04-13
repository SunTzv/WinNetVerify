@echo off
set "PS_PATH=C:\ProgramData\WinNetVerify\WinNet.ps1"
if "%1"=="llm-on" (
    powershell -ExecutionPolicy Bypass -File "%PS_PATH%" on
    echo [+] nCrypt: Network OPEN
) else if "%1"=="llm-off" (
    powershell -ExecutionPolicy Bypass -File "%PS_PATH%" off
    echo [!] nCrypt: Network RESTRICTED
) else (
    echo Usage: nc [llm-on ^| llm-off]
)
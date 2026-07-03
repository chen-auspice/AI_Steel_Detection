@echo off
REM ============================================================
REM Firmware Build Script (Windows Batch Wrapper)
REM
REM Usage:
REM   build.bat                  Full build (STEdgeAI + CubeIDE + HEX)
REM   build.bat --skip-generate  Skip STEdgeAI, compile + HEX only
REM   build.bat --hex-only       Pack HEX only (need existing build)
REM
REM Tool paths can be set via environment variables:
REM   set CUBEIDE_PATH=D:\App\STM32CubeIDE\stm32cubeidec.exe
REM   set STEDGEAI_PATH=D:\App\STEdgeAI\2.0\Utilities\windows\stedgeai.exe
REM   set GCC_BIN_PATH=D:\App\STM32CubeIDE\plugins\...\tools\bin
REM ============================================================

setlocal

REM Get script directory
set SCRIPT_DIR=%~dp0

REM Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found. Please ensure Python is in PATH.
    exit /b 1
)

REM Run build script
python "%SCRIPT_DIR%build_firmware.py" %*
exit /b %errorlevel%

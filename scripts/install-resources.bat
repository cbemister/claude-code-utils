@echo off
REM Install Claude Code Skills for Windows
REM Copies skill sources from this repo to %USERPROFILE%\.claude\skills\

setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "REPO_DIR=%SCRIPT_DIR%.."
set "SKILLS_SRC=%REPO_DIR%\.claude\skills"
set "SKILLS_DEST=%USERPROFILE%\.claude\skills"

echo.
echo Claude Code Skills Installer
echo ==============================
echo.

REM Check if skills source directory exists
if not exist "%SKILLS_SRC%" (
    echo Error: Skills source directory not found: %SKILLS_SRC%
    exit /b 1
)

REM Parse arguments
set "INSTALL_ALL=true"
set "SKILL_NAME="

if "%1"=="--help" goto :help
if "%1"=="-h" goto :help
if "%1"=="--list" goto :list
if not "%1"=="" if not "%1"=="--all" (
    set "INSTALL_ALL=false"
    set "SKILL_NAME=%1"
)

REM Install skills
if "%INSTALL_ALL%"=="true" (
    echo Installing all skills to: %SKILLS_DEST%
    echo.

    for /D %%d in ("%SKILLS_SRC%\*") do (
        if exist "%%d\SKILL.md" (
            set "skill_name=%%~nd"
            set "dest_dir=%SKILLS_DEST%\%%~nd"

            if not exist "!dest_dir!" mkdir "!dest_dir!"
            copy /Y "%%d\SKILL.md" "!dest_dir!\SKILL.md" >nul

            echo   [92m✓[0m Installed: %%~nd
        )
    )
) else (
    REM Install specific skill
    set "skill_dir=%SKILLS_SRC%\%SKILL_NAME%"

    if not exist "!skill_dir!\SKILL.md" (
        echo Error: Skill not found: %SKILL_NAME%
        echo.
        echo Available skills:
        for /D %%d in ("%SKILLS_SRC%\*") do (
            if exist "%%d\SKILL.md" echo   - %%~nd
        )
        exit /b 1
    )

    echo Installing skill: %SKILL_NAME%
    echo.

    set "dest_dir=%SKILLS_DEST%\%SKILL_NAME%"
    if not exist "!dest_dir!" mkdir "!dest_dir!"
    copy /Y "!skill_dir!\SKILL.md" "!dest_dir!\SKILL.md" >nul

    echo   [92m✓[0m Installed: %SKILL_NAME%
)

echo.
echo [92m✓ Installation complete![0m
echo.
echo [93mNext steps:[0m
echo   1. Restart Claude Code (close and reopen VSCode)
echo   2. Skills will appear as slash commands (e.g., /create-plan)
echo.
echo Installed skills location: %SKILLS_DEST%
echo.
goto :end

:help
echo Usage:
echo   %~nx0              # Install all skills (default)
echo   %~nx0 --all        # Install all skills
echo   %~nx0 ^<skill-name^> # Install specific skill
echo   %~nx0 --list       # List available skills
echo.
goto :end

:list
echo Available skills:
for /D %%d in ("%SKILLS_SRC%\*") do (
    if exist "%%d\SKILL.md" echo   - %%~nd
)
echo.
goto :end

:end
endlocal

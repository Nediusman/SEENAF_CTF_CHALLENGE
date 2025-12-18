@echo off
REM SEENAF CTF Platform - Automated Supabase Setup Script (Windows)
REM This script helps you set up Supabase configuration quickly

echo.
echo ========================================
echo SEENAF CTF Platform - Supabase Setup
echo ========================================
echo.

REM Check if .env already exists
if exist .env (
    echo WARNING: .env file already exists!
    set /p overwrite="Do you want to overwrite it? (y/N): "
    if /i not "%overwrite%"=="y" (
        echo Setup cancelled. Keeping existing .env file.
        exit /b 0
    )
)

REM Create .env.example if it doesn't exist
if not exist .env.example (
    echo Creating .env.example template...
    (
        echo # Supabase Configuration
        echo VITE_SUPABASE_PROJECT_ID=your_project_id_here
        echo VITE_SUPABASE_PUBLISHABLE_KEY=your_anon_key_here
        echo VITE_SUPABASE_URL=https://your-project-id.supabase.co
    ) > .env.example
)

echo.
echo Please provide your Supabase credentials
echo (Find these in your Supabase project: Settings -^> API^)
echo.

REM Get Supabase URL
set /p SUPABASE_URL="Supabase URL (e.g., https://xxxxx.supabase.co): "

REM Extract project ID from URL
for /f "tokens=3 delims=/." %%a in ("%SUPABASE_URL%") do set PROJECT_ID=%%a
if not "%PROJECT_ID%"=="" (
    echo    Project ID detected: %PROJECT_ID%
) else (
    set /p PROJECT_ID="Project ID (from URL): "
)

REM Get anon key
echo.
set /p ANON_KEY="Anon/Public Key (starts with eyJ...): "

REM Validate inputs
if "%SUPABASE_URL%"=="" (
    echo ERROR: Supabase URL is required!
    exit /b 1
)
if "%PROJECT_ID%"=="" (
    echo ERROR: Project ID is required!
    exit /b 1
)
if "%ANON_KEY%"=="" (
    echo ERROR: Anon Key is required!
    exit /b 1
)

REM Create .env file
echo.
echo Creating .env file...
(
    echo # Supabase Configuration
    echo # Generated on %date% %time%
    echo.
    echo VITE_SUPABASE_PROJECT_ID=%PROJECT_ID%
    echo VITE_SUPABASE_PUBLISHABLE_KEY=%ANON_KEY%
    echo VITE_SUPABASE_URL=%SUPABASE_URL%
) > .env

echo .env file created successfully!
echo.

REM Check if node_modules exists
if not exist node_modules (
    echo Installing dependencies...
    call npm install
    echo Dependencies installed!
    echo.
)

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo Next Steps:
echo    1. Go to your Supabase project: https://app.supabase.com/
echo    2. Open SQL Editor
echo    3. Run 'complete-setup.sql' to set up the database
echo    4. Run 'load-all-68-challenges.sql' to load challenges
echo    5. Start the dev server: npm run dev
echo.
echo For detailed instructions, see SETUP_GUIDE.md
echo.

pause

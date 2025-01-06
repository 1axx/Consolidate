@echo off
setlocal enabledelayedexpansion

:: Set the parent folder to Downloads where the .bat file is located
set "parentFolder=%USERPROFILE%\Downloads"

:: Ask the user to provide the folder to consolidate (relative to Downloads)
echo Please specify the folder to consolidate (relative to Downloads):
set /p "folderName=Enter the folder name: "

:: Check if the specified folder exists
set "sourceFolder=%parentFolder%\%folderName%"
if not exist "%sourceFolder%" (
    echo The folder "%folderName%" does not exist in the Downloads directory. Exiting.
    pause
    exit /b
)

:: Ask the user to provide a name for the new folder
set "defaultName=Consolidated"
set /p "customName=Enter a name for the new folder (default: Consolidated): "

:: Use the provided name or fallback to the default
if "%customName%"=="" (
    set "targetFolder=%parentFolder%\%defaultName%"
) else (
    set "targetFolder=%parentFolder%\%customName%"
)

:: Create the new folder for consolidated files
if not exist "%targetFolder%" mkdir "%targetFolder%"

:: Counter for renaming duplicates
set /a counter=1

:: Loop through all files in the source folder and its subfolders
for /r "%sourceFolder%" %%f in (*) do (
    if not "%%~dpf"=="%targetFolder%\" (
        set "fileName=%%~nxf"
        set "newFileName=!fileName!"

        :: Rename if a file with the same name already exists
        if exist "%targetFolder%\!newFileName!" (
            set "newFileName=%%~nxf_!counter!%%~xf"
            set /a counter+=1
        )

        :: Move the file to the consolidated folder
        move "%%f" "%targetFolder%\!newFileName!" >nul
    )
)

:: Move the new folder to the Downloads folder (if not already there)
if /i not "%targetFolder%"=="%parentFolder%\%folderName%" (
    move "%targetFolder%" "%parentFolder%\"
)

:: Delete the old folder after consolidation
rd /s /q "%sourceFolder%"

echo All files have been consolidated, the new folder has been moved to Downloads, and the old folder has been deleted.
pause

@echo off
setlocal EnableDelayedExpansion

rem Set output directory - modify this path as needed
set "DOCS_OUTPUT_DIR=C:/Nexeed/Docsoutput"

rem Check if output directory exists
if not exist "%DOCS_OUTPUT_DIR%" (
    echo Creating output directory: %DOCS_OUTPUT_DIR%
    mkdir "%DOCS_OUTPUT_DIR%"
)

rem List available .adoc files (excluding index.adoc)
echo Available .adoc files:
set /a counter=1
for %%F in (modules\ROOT\pages\*.adoc) do (
    set "filename=%%~nxF"
    if not "!filename!"=="index.adoc" (
        echo !counter!. !filename!
        set "file!counter!=!filename!"
        set /a counter+=1
    )
)

rem Get user input
set /p selections="Enter the numbers of the files you want to include (separated by spaces): "

rem Convert selections to filenames
set "selected_files="
for %%n in (%selections%) do (
    if defined file%%n (
        if defined selected_files (
            set "selected_files=!selected_files!,!file%%n!"
        ) else (
            set "selected_files=!file%%n!"
        )
    )
)

rem Debug output
echo Selected files: %selected_files%
echo Output directory: %DOCS_OUTPUT_DIR%

rem Set environment variables and run Antora
set SELECTED_FILES=%selected_files%
call npx antora antora-playbook.yml

echo.
echo Build complete! Check %DOCS_OUTPUT_DIR% for your generated site.
echo.

endlocal
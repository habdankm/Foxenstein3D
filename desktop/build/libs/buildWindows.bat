@echo off

rem This is a script to build executable for Windows.
rem I use this because I cant build for Windows on Linux somehow.

rem This will first build the game .jar file using Gradle.
rem After that it will build executable for Windows.
rem At last it will zip the executable.

set "msg=SCRIPT STATUS:"
set /A script_status=1

rem Message
echo %msg% Running Windows build script...
rem Move to project root folder.
cd ..\..\.. || echo %msg% Could not find project root folder. && exit /b

rem Message
echo %msg% Building jar file using gradlew...
rem Build game .jar file.
call gradlew desktop:dist && echo %msg% Building .jar file succeeded. || echo %msg% Building .jar file failed. && exit /b

rem Cd to libs:
cd desktop\build\libs || %msg% Could not find desktop/build/libs folder. && exit /b

rem Message WINDOWS ONLY
echo %msg% Removing old game title .jar.
rem Remove old game title jar.
if exist UltraNightmare.jar (
    del /S /F /Q UltraNightmare.jar && echo %msg% Removing old -game title- jar folder. || echo %msg% Failed to remove old -game title- jar folder! && exit /b
) else (
    echo %msg% There is no old -game title- jar file: Skipping this step.
)

rem Message
echo %msg% Renaming jar file to game title...
rem Rename standard jar file name with title of game.
ren desktop-1.0.jar UltraNightmare.jar && echo %msg% Renaming .jar file succeeded. || echo %msg% Renaming .jar file failed. && exit /b

rem Message
echo %msg% Removing old platform folder if it exists... This MUST be done.
rem Remove old platform folder.
if exist UltraNightmare_Windows (
    rmdir /S /Q UltraNightmare_Windows && echo %msg% Removing old Windows executable folder. || echo %msg% Failed to remove platform directory! && exit /b
) else (
    echo %msg% There is no Windows executable folder: Skipping this step.
)

rem Message
echo %msg% Building Windows executable using Packr...
rem Build Windows executable using Packr and its own .json file.
if exist packr-all-3.0.1.jar (
    java -jar packr-all-3.0.1.jar buildExecutableWindows64.json || echo %msg% Failed to use Packr with Json file! && exit /b
) else (
    echo %msg% Could not find Packr. This is needed in \libs folder. && exit /b
)

rem Message
echo %msg% Zipping Windows executable folder...
rem Zip the folder containg platform executable
if exist UltraNightmare_Windows (
    tar.exe -a -c -f UltraNightmare_Windows.zip UltraNightmare_Windows || echo %msg% Failed to zip platform executable folder. && exit /b
) else (
    echo %msg% There is no Windows executable folder to be used for zip. && exit /b
)

set /A script_status=0

if /I "%script_status%" EQU "0" (
    echo %msg% Done!
) else (
    echo %msg% Failed!
)

exit /b

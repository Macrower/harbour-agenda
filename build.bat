@echo off

echo ===== BUILD AGENDA HARBOUR =====

hbmk2 src\agenda.prg

if not exist build mkdir build

move agenda.exe build\agenda.exe

echo.
echo Build concluido.

pause
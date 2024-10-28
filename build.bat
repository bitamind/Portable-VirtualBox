@echo off       

rem Unseting user variables
set "aut2exe=%ProgramFiles(x86)%\AutoIt3\Aut2Exe\aut2exe.exe"

rem User-defined variables. You may have to change its values to correspond to your system and remove the "rem" statement in front of it.
rem set "aut2exe=C:\Program Files (x86)\AutoIt3\Aut2Exe\aut2exe.exe"
rem End of user-defined variables.



rem Setting up the different folders used for building. %~dp0 is the folder of the build script itself (may not be the same as the working directory).
set "input_folder=%~dp0"
set "build_folder=%input_folder%\build\source"
set "release_folder=%input_folder%\build\release"
set "output_name=Portable-VirtualBox_current.exe"


rem Find path for aut2exe
rem If the user supplied a aut2exe path use it
IF DEFINED aut2exe (
	echo Using user defind path to aut2exe
	goto done_aut2exe
)

rem Try to find the aut2exe path.
set "PPATH=%ProgramFiles%\AutoIt3\Aut2Exe\aut2exe.exe"
IF exist "%PPATH%" (
    set "aut2exe=%PPATH%"
	goto done_aut2exe
) 

set "PPATH=%ProgramFiles(x86)%\AutoIt3\Aut2Exe\aut2exe.exe"
IF exist "%PPATH%" (
    set "aut2exe=%PPATH%"
	goto done_aut2exe
) 

:done_aut2exe
IF not exist "%aut2exe%" (
    echo Can't locate AutoIt. Is it installed? Pleas set the aut2exe variable if it is installed in a nonstandard path.
    EXIT /B
)


echo aut2exe path: %aut2exe%

rem Remove any old files in the build directory.
if exist "%build_folder%\Portable-VirtualBox" (
	rmdir /s /q %build_folder%\Portable-VirtualBox
)

rem Create build and release folders if needed.
if not exist "%build_folder%\Portable-VirtualBox" md "%build_folder%\Portable-VirtualBox"
if not exist "%release_folder%" md "%release_folder%"

rem Make a copy of the file for easy compression later.
xcopy /i /e "%input_folder%data" "%build_folder%\Portable-VirtualBox\data\"
xcopy /i /e "%input_folder%source" "%build_folder%\Portable-VirtualBox\source\"
xcopy "%input_folder%LiesMich.txt" "%build_folder%\Portable-VirtualBox\"
xcopy "%input_folder%ReadMe.txt"  "%build_folder%\Portable-VirtualBox\"

rem Compile Portable-VirtualBox.
"%aut2exe%" /in "%build_folder%\Portable-VirtualBox\source\Portable-VirtualBox.au3" /out "%build_folder%\Portable-VirtualBox\Portable-VirtualBox.exe" /x86
if not exist "%build_folder%\Portable-VirtualBox\Portable-VirtualBox.exe" (
	echo Failed to build exe. No .exe file was produced
	EXIT /B
)

echo ###############################################################################
echo Build new release as %release_folder%\%output_name%
echo ###############################################################################


@echo off
type "%~dp0asset\logo.txt"
@echo.
rem @echo                               _,add8ba,
rem @echo                             ,d888888888b,
rem @echo                            d8888888888888b                        _,ad8ba,_
rem @echo                           d888888888888888)                     ,d888888888b,
rem @echo                           I8888888888888888 _________          ,8888888888888b
rem @echo                 __________`Y88888888888888P"""""""""""baaa,__ ,888888888888888,
rem @echo             ,adP"""""""""""9888888888P""^                 ^""Y8888888888888888I
rem @echo          ,a8"^           ,d888P"888P^                           ^"Y8888888888P'
rem @echo        ,a8^            ,d8888'                                     ^Y8888888P'
rem @echo       a88'           ,d8888P'                                        I88P"^
rem @echo     ,d88'           d88888P'                                          "b,
rem @echo    ,d88'           d888888'                                            `b,
rem @echo   ,d88'           d888888I                                              `b,
rem @echo   d88I           ,8888888'            ___                                `b,
rem @echo  ,888'           d8888888          ,d88888b,              ____            `b,
rem @echo  d888           ,8888888I         d88888888b,           ,d8888b,           `b
rem @echo ,8888           I8888888I        d8888888888I          ,88888888b           8,
rem @echo I8888           88888888b       d88888888888'          8888888888b          8I
rem @echo d8886           888888888       Y888888888P'           Y8888888888,        ,8b
rem @echo 88888b          I88888888b      `Y8888888^             `Y888888888I        d88,
rem @echo Y88888b         `888888888b,      `""""^                `Y8888888P'       d888I
rem @echo `888888b         88888888888b,                           `Y8888P^        d88888
rem @echo  Y888888b       ,8888888888888ba,_          _______        `""^        ,d888888
rem @echo  I8888888b,    ,888888888888888888ba,_     d88888888b               ,ad8888888I
rem @echo  `888888888b,  I8888888888888888888888b,    ^"Y888P"^      ____.,ad88888888888I
rem @echo   88888888888b,`888888888888888888888888b,     ""      ad888888888888888888888'
rem @echo   8888888888888698888888888888888888888888b_,ad88ba,_,d88888888888888888888888
rem @echo   88888888888888888888888888888888888888888b,`"""^ d8888888888888888888888888I
rem @echo   8888888888888888888888888888888888888888888baaad888888888888888888888888888'
rem @echo   Y8888888888888888888888888888888888888888888888888888888888888888888888888P
rem @echo   I888888888888888888888888888888888888888888888P^  ^Y8888888888888888888888'
rem @echo   `Y88888888888888888P88888888888888888888888888'     ^88888888888888888888I
rem @echo    `Y8888888888888888 `8888888888888888888888888       8888888888888888888P'
rem @echo     `Y888888888888888  `888888888888888888888888,     ,888888888888888888P'
rem @echo      `Y88888888888888b  `88888888888888888888888I     I888888888888888888'
rem @echo        "Y8888888888888b  `8888888888888888888888I     I88888888888888888'
rem @echo          "Y88888888888P   `888888888888888888888b     d8888888888888888'
rem @echo             ^""""""""^     `Y88888888888888888888,    888888888888888P'
rem @echo                              "8888888888888888888b,   Y888888888888P^
rem @echo                               `Y888888888888888888b   `Y8888888P"^
rem @echo                                 "Y8888888888888888P     `""""^
rem @echo                                   `"YY88888888888P'
@echo Sad Panda [Pre]Compiling %name%

if "%~1"=="" (
	goto Help
) else if "%~1"=="/?" (
	goto Help
) else if "%~2"=="" (
	Set name=%1
)

set runProc=%temp%\Lexi_%random%%random%%random%%random%%random%.proc

@echo Load "%~dp0BambooForest.br",resident   >%runProc%
@echo Load "%~dp0Compile.br"                 >>%runProc%
@echo Run                                    >>%runProc%

"%~dp0br.exe" proc "%runProc%"

goto End

:Err
echo Syntax Error, there was something wrong with your command.
echo you said:
echo %0
echo See the correct usage below.
:Help
echo Compiles from Business Rules! source to program.
echo.
echo    or
echo %~n0  [name]                                 (only one parameter)
echo.
echo If you use 1 parameter it may be a long file name with spaces that is encapsulated in double quotes.
echo.
echo [name]       = the name with the extension and the path.
echo.
echo NOTE: The destination program file will be the same as the source file
echo       only it will have a .br extension instead.
echo.
:End

@echo off
set hostname=%COMPUTERNAME%
set breakout=BREAKOUT
set dominus=DOMINUS
set jcdenton=JCDENTON
set octane=OCTANE

set ahk_script=dotfiles\.ahk
if %hostname% == %jcdenton% (
    set ahk_program=%userprofile%\home\sys\prgf\auto_hotkey\AutoHotKeyU64.exe
    goto start_ahk
)
if %hostname% == %octane% (
    set ahk_program=%userprofile%\home\sys\prgf\auto_hotkey\AutoHotKeyU64.exe
    goto start_ahk
)
goto end

:start_ahk
start %ahk_program% %ahk_script%
goto end

:end

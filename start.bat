@echo off
set hostname=%COMPUTERNAME%
set breakout=BREAKOUT
set octane=OCTANE

set ahk_script=dotfiles\.ahk
if %hostname% == %octane% (
  set ahk_program=%userprofile%\home\sys\prgf\auto_hotkey\v2\AutoHotkey64.exe
  goto start_ahk
)
if %hostname% == %breakout% (
  set ahk_program=C:\home\sys\prgf\auto_hotkey\AutoHotKey64.exe
  goto start_ahk
)
goto end

:start_ahk
start %ahk_program% %ahk_script%
goto end

:end

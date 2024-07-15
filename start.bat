@echo off
set hostname=%COMPUTERNAME%
set breakout=BREAKOUT
set octane=OCTANE

set ahk_script=dotfiles\.ahk
if %hostname% == %octane% (
  set ahk_program=%userprofile%\home\sys\win64\prgf\auto_hotkey_2.0\v2\AutoHotkey64.exe
  set wincompose_program=%userprofile%\home\sys\win64\prgf\WinCompose_0.9.11\wincompose.exe
  goto start_ahk
)
if %hostname% == %breakout% (
  set ahk_program=C:\home\sys\prgf\auto_hotkey\AutoHotKey64.exe
  goto start_ahk
)
goto end

:start_ahk
start %ahk_program% %ahk_script%
start %wincompose_program%
goto end

:end

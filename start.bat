@echo off
set hostname=%COMPUTERNAME%
set breakout=BREAKOUT
set octane=OCTANE

set ahk_script=dotfiles\.ahk
if %hostname% == %octane% (
  start %userprofile%\home\sys\win64\prgf\auto_hotkey_2.0\v2\AutoHotkey64.exe %ahk_script%
  start %userprofile%\home\sys\win64\prgf\WinCompose_0.9.11\wincompose.exe
)
if %hostname% == %breakout% (
  start C:\home\sys\win64\prgf\AutoHotkey_2.0.19\AutoHotkey64.exe %ahk_script%
)


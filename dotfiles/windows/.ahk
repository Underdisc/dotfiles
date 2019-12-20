#InstallKeybdHook

!d::
FormatTime, date,, yy-MM-dd
Send, %date%
return

!v::
Run, %A_ProgramFiles%\Notepad++\notepad++.exe U:\ctd.vault
return

!j::Send,{Down}
!k::Send,{Up}
!h::Send,{Left}
!l::Send,{Right}

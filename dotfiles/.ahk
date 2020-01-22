breakout := "breakout"
dominus := "dominus"
jcdenton := "JCDenton"
octane := "octane"

!d::
FormatTime, date,, yy-MM-dd
Send, %date%
return

!v::
if(%A_ComputerName% == %octane%)
{
    Run, C:\Users\underdisc\home\sys\prgf\notepadpp\notepad++.exe U:\ctd.vault
}
else if(%A_ComputerName% == %jcdenton%)
{
    Run, %ProgramFiles%\Notepad++\notepad++.exe U:\ctd.vault
}
return

!j::Send,{Down}
!k::Send,{Up}
!h::Send,{Left}
!l::Send,{Right}


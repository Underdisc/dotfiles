breakout := "breakout"
dominus := "dominus"
jcdenton := "jcdenton"
octane := "octane"

!d::
FormatTime, date,, yy-MM-dd
Send, %date%
return

!v::
MsgBox %A_ComputerName%
if(%A_ComputerName% == %octane%)
{
    Run, C:\Users\underdisc\home\sys\prgf\notepadpp\notepad++.exe U:\ctd.vault
}
return

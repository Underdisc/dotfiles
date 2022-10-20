breakout := "breakout"
octane := "octane"

!d::
FormatTime, date,, yy-MM-dd
Send, %date%
return

!v::
if(%A_ComputerName% == %octane%)
{
  Run, C:\Users\underdisc\home\sys\prgf\npp\notepad++.exe U:\ctd.vault
}
return

!j::Send,{Down}
!k::Send,{Up}
!h::Send,{Left}
!l::Send,{Right}

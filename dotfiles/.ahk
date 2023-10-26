!d:: {
  date := FormatTime(,"yy-MM-dd")
  Send date
}

!v:: {
  if (A_ComputerName == "OCTANE") {
    Run "C:\Users\underdisc\home\sys\prgf\npp\notepad++.exe D:\user\underdisc\vault\ctd.vault"
  }
  else if (A_ComputerName == "BREAKOUT") {
    Run "C:\home\sys\prgf\npp_8.1.4\notepad++.exe C:\home\vault\ctd.vault"
  }
}

!j::Send("{Down}")
!k::Send("{Up}")
!h::Send("{Left}")
!l::Send("{Right}")

#HotIf WinActive("-bash")
^v::+Ins
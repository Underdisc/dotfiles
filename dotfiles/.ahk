!d:: {
  date := FormatTime(,"yy-MM-dd")
  Send date
}

!v:: {
  if (A_ComputerName == "octane") {
    Run("C:\Users\underdisc\home\sys\prgf\npp\notepad++.exe",,"U:\ctd.vault")
  }
  else if (A_ComputerName == "JOEY-GUESKTOP") {
    Run("C:\home\sys\prgf\npp\notepad++.exe U:\ctd.vault")
  }
}

!j::Send("{Down}")
!k::Send("{Up}")
!h::Send("{Left}")
!l::Send("{Right}")

#HotIf WinActive("-bash")
^v::+Ins
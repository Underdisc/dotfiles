!d:: {
  date := FormatTime(,"yy-MM-dd")
  Send date
}

!v:: {
  if (A_ComputerName == "OCTANE") {
    Run "C:\Users\underdisc\home\sys\win64\prgf\npp_7.8.5\notepad++.exe D:\user\underdisc\vault\ctd.vault"
  }
  else if (A_ComputerName == "BREAKOUT") {
    Run "C:\home\sys\prgf\npp_8.1.4\notepad++.exe C:\home\vault\ctd.vault"
  }
}

#HotIf WinActive("FL Studio 20")
XButton2::p
C_LONGINT:C283(iHelpItem; hlHelp)
iHelpItem:=0
hlHelp:=0
NewWindow(Screen width:C187-15; Screen height:C188-70; 2; Has zoom box:K34:9; "Help"; "wCloseWinBox")
READ ONLY:C145([x_help:8])
FORM SET INPUT:C55([x_help:8]; "activityProduction")
ADD RECORD:C56([x_help:8])
CLOSE WINDOW:C154
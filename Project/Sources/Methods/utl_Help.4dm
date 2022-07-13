//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// User name (OS): MLB
// Date and time: 3/01/00
// ----------------------------------------------------
// Method: utl_Help
// Description:
// Shows the Help screen.
// ----------------------------------------------------

C_TEXT:C284($1)

If (Count parameters:C259=1)
	$id:=uSpawnProcess("utl_Help"; 64000; "Help"; True:C214; True:C214)
	
Else 
	C_LONGINT:C283(iHelpItem; hlHelp)
	iHelpItem:=0
	hlHelp:=0
	$today:=4D_Current_date
	SET MENU BAR:C67(<>DefaultMenu)
	NewWindow(700; Screen height:C188-70; 2; Has zoom box:K34:9; "Help"; "wCloseWinBox")  // Modified by: Mark Zinke (1/22/13) Makes is easier to read. Smaller width.
	READ ONLY:C145([x_help:8])
	FORM SET INPUT:C55([x_help:8]; "HelpStartPage")
	Repeat 
		ADD RECORD:C56([x_help:8])
	Until (bDone=1)
	
	CLOSE WINDOW:C154
	uWinListCleanup
End if 
//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 02/28/08, 11:15:47
// ----------------------------------------------------
// Method: HR_openPalette
// ----------------------------------------------------

SET MENU BAR:C67(<>DefaultMenu)

NewWindow(230; 250; 1; 0; "EDI Event"; "wCloseWinBox")
DIALOG:C40([zz_control:1]; "EDIEvent")
CLOSE WINDOW:C154
uWinListCleanup
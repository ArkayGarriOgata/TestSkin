//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: gCaddEvent
// Description:
// Cadd Event Handler
// ----------------------------------------------------

NewWindow(500; 90; 1; 4; "Address Palette"; "wCloseWinBox")  // Modified by: Mark Zinke (2/6/13) Type was 0.

SET MENU BAR:C67(<>DefaultMenu)

DIALOG:C40([zz_control:1]; "CaddEvent")
uWinListCleanup
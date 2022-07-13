//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: gCCEvent
// Description:
// CC Event Handler
// ----------------------------------------------------

NewWindow(500; 150; 1; 4; "Cost Center Palette"; "wCloseWinBox")  // Modified by: Mark Zinke (2/6/13) Type was 0
SET MENU BAR:C67(<>DefaultMenu)

DIALOG:C40([zz_control:1]; "CCEvent")
CLOSE WINDOW:C154
uWinListCleanup
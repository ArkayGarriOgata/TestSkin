//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: FG_OpenPalette
// Description:
// FG Event Handler
// ----------------------------------------------------

NewWindow(437; 220; 1; 4; "Finished Goods Palette"; "wCloseWinBox")  // Modified by: Mark Zinke (2/7/13) Type was 0.
SET MENU BAR:C67(<>DefaultMenu)

DIALOG:C40([zz_control:1]; "FGEvent")
CLOSE WINDOW:C154
uWinListCleanup
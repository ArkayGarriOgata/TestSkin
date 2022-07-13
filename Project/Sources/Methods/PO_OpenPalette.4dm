//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: PO_OpenPalette
// Description:
// PO Event Handler
// ----------------------------------------------------

NewWindow(500; 150; 1; 4; "Purchasing Palette"; "wCloseWinBox")  // Modified by: Mark Zinke (2/8/13) Type was 0.
SET MENU BAR:C67(<>DefaultMenu)

DIALOG:C40([zz_control:1]; "POEvent")
CLOSE WINDOW:C154
uWinListCleanup
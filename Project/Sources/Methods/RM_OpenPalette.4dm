//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: RM_OpenPalette
// Description:
// RM Event Handler
// ----------------------------------------------------

NewWindow(513; 173; 1; 4; "Raw Material Palette"; "wCloseWinBox")  // Modified by: Mark Zinke (2/8/13) Type was 0, Heigth was 150
SET MENU BAR:C67(<>DefaultMenu)

DIALOG:C40([zz_control:1]; "RMEvent")
CLOSE WINDOW:C154
uWinListCleanup
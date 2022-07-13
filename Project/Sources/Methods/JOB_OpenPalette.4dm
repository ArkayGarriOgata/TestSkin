//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: JOB_OpenPalette
// Description:
// Estimate Event Handler
// ----------------------------------------------------

NewWindow(508; 191; 1; 4; "Jobs Palette"; "wCloseWinBox")  // Modified by: Mark Zinke (2/6/13) Type was 4.
SET MENU BAR:C67(<>DefaultMenu)

DIALOG:C40([zz_control:1]; "JobsEvent")
CLOSE WINDOW:C154
uWinListCleanup
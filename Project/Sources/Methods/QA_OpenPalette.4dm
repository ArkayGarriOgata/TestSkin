//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: QA_OpenPalette
// ----------------------------------------------------

NewWindow(420; 312; 1; 4; "QA Palette"; "wCloseWinBox")  // Modified by: Mark Zinke (2/7/13) Type was 0.
SET MENU BAR:C67(<>DefaultMenu)

DIALOG:C40([zz_control:1]; "QApalette")
CLOSE WINDOW:C154
uWinListCleanup
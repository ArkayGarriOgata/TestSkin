//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: gReqEvent
// Description:
// Req Event Handler
// ----------------------------------------------------

NewWindow(500; 160; 1; 4; "Requisitions Palette"; "wCloseWinBox")  // Modified by: Mark Zinke (2/7/13) Type was 0, heigth was 150
SET MENU BAR:C67(<>DefaultMenu)

DIALOG:C40([zz_control:1]; "ReqEvent")
CLOSE WINDOW:C154
uWinListCleanup
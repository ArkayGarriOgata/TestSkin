//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: gCustEvent
// Description:
// Cust Event Handler
// ----------------------------------------------------

NewWindow(500; 150; 1; 4; "Customer Palette"; "wCloseWinBox")  // Modified by: Mark Zinke (2/6/13) Type was 0
SET MENU BAR:C67(<>DefaultMenu)
DIALOG:C40([zz_control:1]; "CustEvent")
CLOSE WINDOW:C154
uWinListCleanup
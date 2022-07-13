//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: gCustOrdEvent
// Description:
// Customer Order Event Handler
// ----------------------------------------------------

NewWindow(500; 150; 1; 4; "Customer Order Palette"; "wCloseWinBox")  // Modified by: Mark Zinke (2/6/13) Type was a 0.
SET MENU BAR:C67(<>DefaultMenu)

DIALOG:C40([zz_control:1]; "CustOrdEvent")
CLOSE WINDOW:C154
uWinListCleanup
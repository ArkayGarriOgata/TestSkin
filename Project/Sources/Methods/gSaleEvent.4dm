//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: gSaleEvent
// Description:
// Salesman Event Handler
// ----------------------------------------------------
If (User in group:C338(Current user:C182; "SalesManager")) | (User in group:C338(Current user:C182; "RoleSuperUser"))
	NewWindow(485; 75; 1; 4; "Sales Rep's Palette"; "wCloseWinBox")  // Modified by: Mark Zinke (2/7/13) Type was 0.
	SET MENU BAR:C67(<>DefaultMenu)
	
	DIALOG:C40([zz_control:1]; "SaleEvent")
	CLOSE WINDOW:C154
	uWinListCleanup
	
Else 
	BEEP:C151
End if 
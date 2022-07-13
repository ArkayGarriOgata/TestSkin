//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/17/07, 15:30:00
// ----------------------------------------------------
// Method: BOL_DeleteBillOfLading()  --> 
// Description:
// Mark a bol as void and put back inventory
// ----------------------------------------------------

If (Not:C34([Customers_Bills_of_Lading:49]WasBilled:29))
	BEEP:C151
	uConfirm("Are you sure you want to VOID BOL# "+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+"?"; "VOID"; "Cancel")
	If (OK=1)
		[Customers_Bills_of_Lading:49]CustID:2:="VOID"
		[Customers_Bills_of_Lading:49]BillTo:4:="VOID"
		[Customers_Bills_of_Lading:49]Carrier:9:="VOID"
		[Customers_Bills_of_Lading:49]ShipTo:3:="VOID"
		[Customers_Bills_of_Lading:49]Total_Wgt:18:=0
		[Customers_Bills_of_Lading:49]Total_Cases:14:=0
		[Customers_Bills_of_Lading:49]Total_Cartons:12:=0
		
		For ($i; 1; Size of array:C274(aLocation2))
			BOL_PutAwayInventory(aLocation2{$i}; aJobit2{$i}; aPallet2{$i})
		End for 
		
		ARRAY BOOLEAN:C223(ListBox1; 0)
		ARRAY LONGINT:C221(aReleases; 0)
		ARRAY LONGINT:C221(aNumCases2; 0)
		ARRAY LONGINT:C221(aPackQty2; 0)
		ARRAY LONGINT:C221(aTotalPicked2; 0)
		ARRAY LONGINT:C221(aWgt2; 0)
		ARRAY TEXT:C222(aLocation2; 0)
		ARRAY LONGINT:C221(aRecNo2; 0)
		ARRAY TEXT:C222(aPallet2; 0)
		SET BLOB SIZE:C606([Customers_Bills_of_Lading:49]BinPicks:27; 0)
		SAVE RECORD:C53([Customers_Bills_of_Lading:49])
	End if 
	
Else 
	uConfirm("BOL# "+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+" was already Billed. Execute a Return."; "Dang"; "Help")
End if 
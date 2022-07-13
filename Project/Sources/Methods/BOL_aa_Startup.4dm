//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/12/07, 12:31:56
// ----------------------------------------------------
// Method: BOL_aa_Startup()  --> 
// ----------------------------------------------------

C_LONGINT:C283(NumRecs1)
C_BOOLEAN:C305($bool)

// this boolean to hide controls and features added to make this look like the 10/22/19 version.
// screen object names will be prefixed with "hide" 
// changes where mixed in with other unrelated changes that shan't be rolled back.

<>iMode:=2
<>filePtr:=->[Customers_Bills_of_Lading:49]
uSetUp(1)
SET MENU BAR:C67(<>DefaultMenu)
$bool:=FG_LaunchItem("init")

FORM SET INPUT:C55([Customers_Bills_of_Lading:49]; "Shipping_Form")
windowTitle:="UNBILLED Bills of Lading"
$winRef:=OpenFormWindow(->[Customers_Bills_of_Lading:49]; "Shipping_Form"; ->windowTitle; windowTitle)

Case of 
	: (Current user:C182="Designer")
		READ WRITE:C146([Customers_Bills_of_Lading:49])
		
	: (Current user:C182="Kristopher Koertge")
		READ WRITE:C146([Customers_Bills_of_Lading:49])
		
	: (User in group:C338(Current user:C182; "RolePlanner"))
		READ ONLY:C145([Customers_Bills_of_Lading:49])
		
	: (User in group:C338(Current user:C182; "ASN_sender"))
		READ WRITE:C146([Customers_Bills_of_Lading:49])
		
	Else 
		READ WRITE:C146([Customers_Bills_of_Lading:49])
End case 

//If (User in group(Current user;"RolePlanner")) & (Current user#"Designer")  //don't all new and update
//READ ONLY([Customers_Bills_of_Lading])
//Else 
//READ WRITE([Customers_Bills_of_Lading])
//End if 
READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Customers_ReleaseSchedules:46])  //toggled to check for locking in BOL_AcceptableRelease
READ ONLY:C145([Customers_Order_Lines:41])
READ ONLY:C145([Finished_Goods_PackingSpecs:91])
READ ONLY:C145([Finished_Goods:26])
READ ONLY:C145([Addresses:30])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	QUERY:C277([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]WasBilled:29=False:C215; *)
	QUERY:C277([Customers_Bills_of_Lading:49];  & ; [Customers_Bills_of_Lading:49]CustID:2#"VOID")
	
	If (User in group:C338(Current user:C182; "RoleRestrictedAccess"))
		QUERY SELECTION:C341([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShippedFrom:5="PR")
	End if 
	
Else 
	
	If (User in group:C338(Current user:C182; "RoleRestrictedAccess"))
		QUERY:C277([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShippedFrom:5="PR"; *)
	End if 
	
	QUERY:C277([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]WasBilled:29=False:C215; *)
	QUERY:C277([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]CustID:2#"VOID")
	
	
End if   // END 4D Professional Services : January 2019 query selection


ORDER BY:C49([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShippersNo:1; <)
NumRecs1:=Records in selection:C76([Customers_Bills_of_Lading:49])
//CREATE SET(filePtr->;"◊LastSelection"+String(fileNum))

SET WINDOW TITLE:C213(String:C10(NumRecs1)+" "+windowTitle)
MODIFY SELECTION:C204([Customers_Bills_of_Lading:49]; *)

REDUCE SELECTION:C351([Customers_Bills_of_Lading:49]; 0)
REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
REDUCE SELECTION:C351([Finished_Goods_PackingSpecs:91]; 0)
REDUCE SELECTION:C351([Finished_Goods:26]; 0)
REDUCE SELECTION:C351([Addresses:30]; 0)
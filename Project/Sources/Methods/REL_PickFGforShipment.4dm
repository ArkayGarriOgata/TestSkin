//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// User name: Mel Bohince
// ----------------------------------------------------
// Method: REL_PickFGforShipment()  --> 
// formerly
//Procedure: gPickFG()    MLB
//Drive the release management layout
//•022597  MLB  optimize and show roan v. haup

C_TEXT:C284(sState)  //•022597  MLB  to show haup or roanoke
C_TEXT:C284(ShipToButtonText; WaitingModeButtonText)
C_LONGINT:C283($numRels; cbCalcInv; bSearch; cbFcst; bShipTos)

ShipToButtonText:="Same ShipTo"
WaitingModeButtonText:="Waiting Mode"
<>iMode:=2
<>filePtr:=->[Customers_ReleaseSchedules:46]
fromDelete:=False:C215
fromZoom:=False:C215
bModMany:=True:C214
uSetUp(1)

READ ONLY:C145([Customers_Order_Lines:41])
READ ONLY:C145([Finished_Goods_Locations:35])
READ WRITE:C146([Customers_ReleaseSchedules:46])
gClearFlags

windowTitle:="(Pick) Release Management"
$winRef:=OpenFormWindow(->[Customers_ReleaseSchedules:46]; "PickWindowSizer"; ->windowTitle; windowTitle)  //;"wCloseOption")
FORM SET OUTPUT:C54([Customers_ReleaseSchedules:46]; "ReleaseMgmt")
FORM SET INPUT:C55([Customers_ReleaseSchedules:46]; "Input")
dDateBegin:=!00-00-00!
dDateEnd:=Current date:C33
ARRAY TEXT:C222(aBilltos; 0)
ARRAY TEXT:C222(aShiptos; 0)
DIALOG:C40([zz_control:1]; "DateRange2")
utl_LogfileServer(<>zResp; "REL_PickFGforShipment "+String:C10(dDateBegin; Internal date short special:K1:4)+" to "+String:C10(dDateEnd; Internal date short special:K1:4); "fg_pick.log")

If (OK=1)
	REL_getRecertificationRequired
	FG_Inventory_Array
	
	$boolean:=FG_ConsignmentItems("init")  //disabled
	$boolean:=FG_LaunchItem("init")
	If (bSearch=0)
		ERASE WINDOW:C160
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5<=dDateEnd; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5>=dDateBegin; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
		$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])
		windowPhrase:=" Open F/G Releases from: "+String:C10(dDateBegin; 1)+" to "+String:C10(dDateEnd; 1)
		windowTitle:=String:C10($numRels)+windowPhrase
		
	Else 
		QUERY:C277([Customers_ReleaseSchedules:46])
		$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])
		windowPhrase:=" F/G Releases (Custom Search)"
		windowTitle:=String:C10($numRels)+windowPhrase
	End if 
	
	cbFcst:=0  //only show shipable when on
	
	Repeat 
		CREATE SET:C116([Customers_ReleaseSchedules:46]; "CurrentSet")
		$numRels:=Records in set:C195("CurrentSet")
		windowTitle:=String:C10($numRels)+windowPhrase
		SET WINDOW TITLE:C213(windowTitle)
		
		If ($numRels>0)
			ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >; [Customers_ReleaseSchedules:46]Shipto:10; >)
			MODIFY SELECTION:C204([Customers_ReleaseSchedules:46]; *)
		Else 
			uConfirm("No releases found."; "OK"; "Help")
			bDone:=1
		End if 
		
		cbFcst:=0  //only show shipable when on
	Until (bDone=1)
	
End if 

FORM SET OUTPUT:C54([Customers_ReleaseSchedules:46]; "List")
CLOSE WINDOW:C154($winRef)

iMode:=0
uClearSelection(->[Finished_Goods_Locations:35])  //•022597  MLB  UPR §
uClearSelection(->[Customers_ReleaseSchedules:46])  //•022597  MLB  UPR §
uClearSelection(->[Customers_Order_Lines:41])  //•022597  MLB  UPR §
CLEAR SET:C117("CurrentSet")  //•022597  MLB  UPR §
uWinListCleanup
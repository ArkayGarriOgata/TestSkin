//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/17/07, 16:10:57
// ----------------------------------------------------
// Method: BOL_inputOnLoad()  --> 
// ----------------------------------------------------

C_LONGINT:C283(release_number; iTotal; numCopies; iSkidWeight; $numBins)
C_BOOLEAN:C305(bol_manifest_refresh_required; bol_manifest_manual_edit)
C_TEXT:C284(pallet_id)
bol_manifest_manual_edit:=False:C215
wWindowTitle("push"; "Bill of Lading "+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1))
iSkidWeight:=40
If (User in group:C338(Current user:C182; "Roanoke"))
	numCopies:=2
Else 
	numCopies:=1
End if 

//lower list box that accumulates the shipment
BOL_ListBox1("init")

$msg:="Enter a Release number then tab to enter cases, packing quantity, and weight per case."
$msg:=$msg+Char:C90(13)+"Or, double-click on pallet id for quick entry."
$msg:=$msg+Char:C90(13)+"Click 'Add to BOL#' to include on this shipment."
If ([Customers_Bills_of_Lading:49]SentToWMS:31)
	READ WRITE:C146([Customers_ReleaseSchedules:46])
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]B_O_L_pending:45=[Customers_Bills_of_Lading:49]ShippersNo:1)
	SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]ReleaseNumber:1; $aRelsSentToWMS)
	SORT ARRAY:C229($aRelsSentToWMS; >)
	$msg:=$msg+Char:C90(13)+"Releases sent to WMS:"
	For ($rel; 1; Size of array:C274($aRelsSentToWMS))
		$msg:=$msg+Char:C90(13)+String:C10($aRelsSentToWMS{$rel})
	End for 
End if 
util_FloatingAlert("Help:"+Char:C90(13)+$msg)

If (Is new record:C668([Customers_Bills_of_Lading:49]))
	[Customers_Bills_of_Lading:49]ShippersNo:1:=app_AutoIncrement(->[Customers_Bills_of_Lading:49])
	[Customers_Bills_of_Lading:49]zCount:6:=1
	[Customers_Bills_of_Lading:49]Status:32:="Manual"
	[Customers_Bills_of_Lading:49]ShipDate:20:=4D_Current_date  //4/5/95 use ship date for xactions and invoice
	Case of 
		: (User in group:C338(Current user:C182; "RoanokeWarehouse"))
			
			[Customers_Bills_of_Lading:49]ShippedFrom:5:="WHSE"
			
		: (User in group:C338(Current user:C182; "Roanoke"))
			[Customers_Bills_of_Lading:49]ShippedFrom:5:="PLANT"
			
		: (User in group:C338(Current user:C182; "RoleRestrictedAccess"))
			[Customers_Bills_of_Lading:49]ShippedFrom:5:="PR"
			SetObjectProperties(""; ->bAskMe; False:C215)
			OBJECT SET ENABLED:C1123(bAskMe; False:C215)
			
		Else 
			[Customers_Bills_of_Lading:49]ShippedFrom:5:="O/S"
	End case 
	
	[Customers_Bills_of_Lading:49]PayUseFlag:11:=-1
	[Customers_Bills_of_Lading:49]PayUse:23:=False:C215
	tText10:="Destination Not Yet Determined"
	tText12:="Billto Not Yet Determined"
	
Else 
	If ([Customers_Bills_of_Lading:49]ShipTo:3#"")
		tText10:=fGetAddressText([Customers_Bills_of_Lading:49]ShipTo:3; "*")
		sCountry:=ADDR_getCountry([Customers_Bills_of_Lading:49]ShipTo:3)
	End if 
	
	If ([Customers_Bills_of_Lading:49]BillTo:4#"")
		tText12:=fGetAddressText([Customers_Bills_of_Lading:49]BillTo:4; "*")
	End if 
	
	If (BLOB size:C605([Customers_Bills_of_Lading:49]BinPicks:27)>0)
		BOL_ListBox1("restore-from-blob")
	End if 
End if 

$numBins:=BOL_PickRelease(0)

BOL_setControls

QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]BillOfLadingNumber:3=[Customers_Bills_of_Lading:49]ShippersNo:1)
ORDER BY:C49([Customers_Invoices:88]; [Customers_Invoices:88]InvoiceNumber:1; >)

RELATE MANY:C262([Customers_Bills_of_Lading:49]Manifest:16)
ORDER BY:C49([Customers_Bills_of_Lading_Manif:181]; [Customers_Bills_of_Lading_Manif:181]Item:1; >)

$msg:=TriggerMessage("load")  //using a record to pass info on cascading triggers
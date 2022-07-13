//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/13/07, 14:47:41
// ----------------------------------------------------
// Method: BOL_PickByPallet()  --> 
// Description
// stage a shipment by entering a pallet or skid number
//
// ----------------------------------------------------
//!!!!!!!!!!!!!!!!!!!!!!!!!!! RE WRITE NEEDED IF THIS IS TURNED BACK ON !!!!!!!!!!!!!!!!!!!
// ----------------------------------------------------

ARRAY BOOLEAN:C223(ListBox2; 0)
ARRAY LONGINT:C221(aNumCases; 0)
ARRAY LONGINT:C221(aPackQty; 0)
ARRAY LONGINT:C221(aTotalPicked; 0)
ARRAY TEXT:C222(aJobit; 0)
ARRAY TEXT:C222(aLocation; 0)
ARRAY LONGINT:C221(aQty; 0)
ARRAY LONGINT:C221(aRecNo; 0)
ARRAY TEXT:C222(aPallet; 0)
C_BOOLEAN:C305($foundWMS)

If (Not:C34(wms_itemExists(pallet_id)))
	$foundWMS:=wms_itemExists("not-by-skidid"; pallet_id)
End if 

If (Records in selection:C76([WMS_ItemMasters:123])=1)
	ARRAY BOOLEAN:C223(ListBox2; 1)
	ARRAY LONGINT:C221(aNumCases; 1)
	ARRAY LONGINT:C221(aPackQty; 1)
	ARRAY LONGINT:C221(aTotalPicked; 1)
	ARRAY TEXT:C222(aJobit; 1)
	ARRAY TEXT:C222(aLocation; 1)
	ARRAY LONGINT:C221(aQty; 1)
	ARRAY LONGINT:C221(aRecNo; 1)
	ARRAY TEXT:C222(aPallet; 1)
	
	aPallet{1}:=pallet_id
	aLocation{1}:=[WMS_ItemMasters:123]LOCATION:4
	aJobit{1}:=[WMS_ItemMasters:123]LOT:3
	aNumCases{1}:=[WMS_ItemMasters:123]CASES:10
	aPackQty{1}:=PK_getCaseCount(FG_getOutline([WMS_ItemMasters:123]SKU:2))
	aQty{1}:=[WMS_ItemMasters:123]QTY:7
	aTotalPicked{1}:=[WMS_ItemMasters:123]QTY:7
	If (aNumCases{1}=0)
		aNumCases{1}:=PK_getCasesPerSkid(FG_getOutline([WMS_ItemMasters:123]SKU:2))
	End if 
	
	If (aNumCases{1}#0) & (aPackQty{1}#0)
		If (aQty{1}#(aNumCases{1}*aPackQty{1}))
			BEEP:C151
			ALERT:C41("Total Qty not equal to (case_quantity x number_of_cases)")
		End if 
	End if 
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=[WMS_ItemMasters:123]LOT:3; *)
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2=[WMS_ItemMasters:123]LOCATION:4)
	If (Records in selection:C76([Finished_Goods_Locations:35])=0)
		aLocation{1}:="WMS-Bin-Invalid"
		aRecNo{1}:=-1
	Else 
		aRecNo{1}:=Record number:C243([Finished_Goods_Locations:35])
	End if 
	
Else 
	uConfirm(pallet_id+" was not found."; "Try Again"; "Help")
	pallet_id:=""
End if 

REDUCE SELECTION:C351([WMS_ItemMasters:123]; 0)
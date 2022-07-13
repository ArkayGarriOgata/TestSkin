//%attributes = {}
// Method: PnG_DeliveryScheduleCompare () -> 
// ----------------------------------------------------
// by: mel: 06/14/05, 10:59:49
// ----------------------------------------------------
// Description:
// display p&g delivery schedule next to aMs release schedule
// ----------------------------------------------------

C_LONGINT:C283($i; $numElements; $winRef; vAskMePID; nextItem)
C_TEXT:C284(billTo)
ARRAY TEXT:C222($aDest2; 0)

vAskMePID:=0  //for the askme btn
COMPARE_CUSTID:="00199"
SET MENU BAR:C67(<>DefaultMenu)
//build popup for each location
ARRAY TEXT:C222(asccName; 0)
QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]Custid:12="00199")
DISTINCT VALUES:C339([Finished_Goods_DeliveryForcasts:145]ShipTo:8; asccName)
$numElements:=Size of array:C274(asccName)

QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12="00199"; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]Shipto:10; $aDest2)

For ($i; 1; Size of array:C274($aDest2))  //merge to get a complete list
	If (Length:C16($aDest2{$i})>0)
		$hit:=Find in array:C230(asccName; $aDest2{$i})
		If ($hit=-1)
			$numElements:=$numElements+1
			ARRAY TEXT:C222(asccName; $numElements)
			asccName{$numElements}:=$aDest2{$i}
		End if 
	End if 
End for 

//put some words next to the shipto id
$numElements:=Size of array:C274(asccName)
For ($i; 1; $numElements)
	If (Length:C16(asccName{$i})>0)
		asccName{$i}:=asccName{$i}+" - "+ADDR_getCity(asccName{$i})
	End if 
End for 
SORT ARRAY:C229(asccName; >)
INSERT IN ARRAY:C227(asccName; 1; 1)
asccName{1}:="P&G"
asccName:=1
asccName{0}:="P&G"

//$winRef:=Open form window([Finished_Goods_DeliveryForcasts];"compare_dio")
windowTitle:="Compare Delivery Schedule"
$winRef:=OpenFormWindow(->[Finished_Goods_DeliveryForcasts:145]; "compare_dio"; ->windowTitle; windowTitle)
FORM SET INPUT:C55([Finished_Goods_DeliveryForcasts:145]; "compare_dio")
sCPN:=""
PnP_DeliveryScheduleQry(sCPN)

currentLocation:=PnG_GetCPNsByLocation  // start with all of them
locationChanged:=currentLocation  //changed by combo box
nextItem:=0
iCnt:=Size of array:C274(aCPN)
billTo:="01957"
While (nextItem<iCnt)  //these can change by user's actions
	FORM SET INPUT:C55([Finished_Goods_DeliveryForcasts:145]; "compare_dio")  //seems like going to detail btn chgs this as a side affect
	If (currentLocation#locationChanged)
		currentLocation:=PnG_GetCPNsByLocation(locationChanged)
		nextItem:=1
		iCnt:=Size of array:C274(aCPN)
		If (currentLocation="02284@")
			billTo:="02181"
		Else 
			billTo:="01957"
		End if 
	Else 
		nextItem:=nextItem+1
	End if 
	bDone:=0
	sCPN:=aCPN{nextItem}
	ADD RECORD:C56([Finished_Goods_DeliveryForcasts:145]; *)  //not going to save this puppy
	
	If (bDone=1)  //closebox clicked
		nextItem:=nextItem+iCnt
	End if 
End while 

CLOSE WINDOW:C154($winRef)
PnP_DeliveryScheduleQry("")
FORM SET INPUT:C55([Finished_Goods_DeliveryForcasts:145]; "input")
ARRAY TEXT:C222(aCPN; 0)
ARRAY TEXT:C222($relCPN; 0)
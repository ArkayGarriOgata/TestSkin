//%attributes = {}
// -------
// Method: Loreal_DeliveryScheduleCompare   ( ) ->
// By: Mel Bohince @ 08/31/16, 13:29:31
// Description
// 
// ----------------------------------------------------

C_LONGINT:C283($i; $numElements; $winRef; vAskMePID; nextItem)
C_TEXT:C284(billTo)

vAskMePID:=0  //for the askme btn
COMPARE_CUSTID:="00765"
SET MENU BAR:C67(<>DefaultMenu)
//build popup for each location
ARRAY TEXT:C222(asccName; 0)
QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]Custid:12=COMPARE_CUSTID)
DISTINCT VALUES:C339([Finished_Goods_DeliveryForcasts:145]ShipTo:8; asccName)
$numElements:=Size of array:C274(asccName)

ARRAY TEXT:C222($aDest2; 0)
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12=COMPARE_CUSTID; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]Shipto:10; $aDest2)

//For ($i;1;Size of array($aDest2))  `merge to get a complete list
//If (Length($aDest2{$i})>0)
//$hit:=Find in array(asccName;$aDest2{$i})
//If ($hit=-1)
//$numElements:=$numElements+1
//ARRAY TEXT(asccName;$numElements)
//asccName{$numElements}:=$aDest2{$i}
//End if 
//End if 
//End for 

//put some words next to the shipto id
$numElements:=Size of array:C274(asccName)
//For ($i;1;$numElements)
//If (asccName{$i}="US")
//asccName{$i}:=asccName{$i}+"  - "+"Domestic"
//Else   //EUR
//asccName{$i}:=asccName{$i}+"  - "+"International"
//End if 
//End for 
SORT ARRAY:C229(asccName; >)
INSERT IN ARRAY:C227(asccName; 1; 1)
asccName{1}:="Lorea"
asccName:=1
asccName{0}:="Lorea"



//$winRef:=Open form window([Finished_Goods_DeliveryForcasts];"compare_dio")
windowTitle:="Compare Delivery Schedule"
$winRef:=OpenFormWindow(->[Finished_Goods_DeliveryForcasts:145]; "compare_dio"; ->windowTitle; windowTitle)
FORM SET INPUT:C55([Finished_Goods_DeliveryForcasts:145]; "compare_dio")
sCPN:=""
PnP_DeliveryScheduleQry(sCPN)

currentLocation:=Loreal_GetCPNsByLocation  // start with all of them
locationChanged:=currentLocation  //changed by combo box
nextItem:=0
iCnt:=Size of array:C274(aCPN)
billTo:="?????"
While (nextItem<iCnt)  //these can change by user's actions
	FORM SET INPUT:C55([Finished_Goods_DeliveryForcasts:145]; "compare_dio")  //seems like going to detail btn chgs this as a side affect
	If (currentLocation#locationChanged)
		currentLocation:=Loreal_GetCPNsByLocation(locationChanged)
		nextItem:=1
		iCnt:=Size of array:C274(aCPN)
		If (currentLocation="US")
			billTo:="?????"
		Else 
			billTo:="?????"
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

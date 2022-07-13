//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 09/16/09, 10:52:40
// ----------------------------------------------------
// Method: ELC_DeliveryScheduleCompare
// ----------------------------------------------------
// based on: PnG_DeliveryScheduleCompare () ->, Arden_DeliveryScheduleCompare 
// ----------------------------------------------------

C_LONGINT:C283($i; $numElements; $winRef; vAskMePID; nextItem)
C_TEXT:C284(billTo)
ARRAY TEXT:C222(aOrderLine; 0)
ARRAY TEXT:C222(asccName; 0)
ARRAY TEXT:C222($aDest2; 0)

vAskMePID:=0  //for the askme btn
COMPARE_CUSTID:="00050"
SET MENU BAR:C67(<>DefaultMenu)
//build popup for each location
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
	
	ELC_query(->[Finished_Goods_DeliveryForcasts:145]Custid:12; 1)
	
	
Else 
	$criteria:=ELC_getName
	READ WRITE:C146([Finished_Goods_DeliveryForcasts:145])
	QUERY BY FORMULA:C48([Finished_Goods_DeliveryForcasts:145]; \
		([Finished_Goods_DeliveryForcasts:145]Custid:12=[Customers:16]ID:1)\
		 & ([Customers:16]ParentCorp:19=$criteria)\
		)
	
End if   // END 4D Professional Services : January 2019 ELC_query

//QUERY([Finished_Goods_DeliveryForcasts];[Finished_Goods_DeliveryForcasts]Custid=COMPARE_CUSTID)
DISTINCT VALUES:C339([Finished_Goods_DeliveryForcasts:145]ShipTo:8; asccName)
$numElements:=Size of array:C274(asccName)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	ELC_query(->[Customers_ReleaseSchedules:46]CustID:12; 1)
	//QUERY([Customers_ReleaseSchedules];[Customers_ReleaseSchedules]CustID=COMPARE_CUSTID;*)
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
	
Else 
	
	READ WRITE:C146([Customers_ReleaseSchedules:46])
	$Critiria:=ELC_getName
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers:16]ParentCorp:19=$Critiria; *)
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
	
End if   // END 4D Professional Services : January 2019 query selection

DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]Shipto:10; $aDest2)

For ($i; 1; Size of array:C274($aDest2))  //merge to get a complete list
	If (Length:C16($aDest2{$i})>0)
		$hit:=Find in array:C230(asccName; $aDest2{$i})
		If ($hit=-1)
			APPEND TO ARRAY:C911(asccName; $aDest2{$i})
		End if 
	End if 
End for 

//put some words next to the shipto id
//$numElements:=Size of array(asccName)
//For ($i;1;$numElements)
//If (asccName{$i}="US")
//asccName{$i}:=asccName{$i}+"  - "+"Domestic"
//Else   `EUR
//asccName{$i}:=asccName{$i}+"  - "+"International"
//End if 
//End for 
SORT ARRAY:C229(asccName; >)
INSERT IN ARRAY:C227(asccName; 1; 1)
asccName{1}:="ELC"
asccName:=1
asccName{0}:="ELC"

//$winRef:=Open form window([Finished_Goods_DeliveryForcasts];"compare_dio")
windowTitle:="Compare Delivery Schedule"
$winRef:=OpenFormWindow(->[Finished_Goods_DeliveryForcasts:145]; "compare_dio"; ->windowTitle; windowTitle)
FORM SET INPUT:C55([Finished_Goods_DeliveryForcasts:145]; "compare_dio")
sCPN:=""
PnP_DeliveryScheduleQry(sCPN)

currentLocation:=ELC_GetCPNsByLocation  // start with all of them
locationChanged:=currentLocation  //changed by combo box
nextItem:=0
iCnt:=Size of array:C274(aCPN)
billTo:="?????"
While (nextItem<iCnt)  //these can change by user's actions
	FORM SET INPUT:C55([Finished_Goods_DeliveryForcasts:145]; "compare_dio")  //seems like going to detail btn chgs this as a side affect
	If (currentLocation#locationChanged)
		currentLocation:=ELC_GetCPNsByLocation(locationChanged)
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
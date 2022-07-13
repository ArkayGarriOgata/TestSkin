//%attributes = {}
// Method: ELC_GetCPNsByLocation (address id) -> 
// ----------------------------------------------------
// by: mel: 06/17/05, 16:53:57
// ----------------------------------------------------
// Description:
// Get all the cpns in an array for a given location
// ----------------------------------------------------

C_TEXT:C284($1)
C_TEXT:C284($destQry; $0)

If (Count parameters:C259=0)
	$destQry:="@"
	$0:="ELC"
Else 
	If ($1#"ELC")
		$destQry:=Substring:C12($1; 1; 5)
		$0:=$destQry
	Else 
		$destQry:="@"
		$0:="ELC"
	End if 
End if 
//get PnG's schedule
ARRAY TEXT:C222(aCPN; 0)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
	
	ELC_query(->[Finished_Goods_DeliveryForcasts:145]Custid:12; 1)
	QUERY SELECTION:C341([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ShipTo:8=$destQry)
	
	
Else 
	
	READ WRITE:C146([Finished_Goods_DeliveryForcasts:145])
	$critiria:=ELC_getName
	QUERY BY FORMULA:C48([Finished_Goods_DeliveryForcasts:145]; \
		([Finished_Goods_DeliveryForcasts:145]Custid:12=[Customers:16]ID:1)\
		 & ([Customers:16]ParentCorp:19=$critiria)\
		 & ([Finished_Goods_DeliveryForcasts:145]ShipTo:8=$destQry)\
		)
	
	
End if   // END 4D Professional Services : January 2019 ELC_query
//QUERY([Finished_Goods_DeliveryForcasts]; & ;[Finished_Goods_DeliveryForcasts]Custid=COMPARE_CUSTID)
DISTINCT VALUES:C339([Finished_Goods_DeliveryForcasts:145]ProductCode:2; aCPN)
$numElements:=Size of array:C274(aCPN)
//get the Arkay schedule
ARRAY TEXT:C222($relCPN; 0)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
	
	ELC_query(->[Customers_ReleaseSchedules:46]CustID:12; 1)
	//QUERY([Customers_ReleaseSchedules];[Customers_ReleaseSchedules]CustID=COMPARE_CUSTID;*)
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10=$destQry; *)
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
	
Else 
	
	READ WRITE:C146([Customers_ReleaseSchedules:46])
	$critiria:=ELC_getName
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers:16]ParentCorp:19=$critiria; *)
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10=$destQry; *)
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
	
End if   // END 4D Professional Services : January 2019 ELC_query

DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]ProductCode:11; $relCPN)

For ($i; 1; Size of array:C274($relCPN))
	If (Length:C16($relCPN{$i})>0)
		$hit:=Find in array:C230(aCPN; $relCPN{$i})
		If ($hit=-1)
			$numElements:=$numElements+1
			ARRAY TEXT:C222(aCPN; $numElements)
			aCPN{$numElements}:=$relCPN{$i}
		End if 
	End if 
End for 
SORT ARRAY:C229(aCPN; >)

$numElements:=Size of array:C274(aCPN)
ARRAY LONGINT:C221($change; $numElements)
For ($i; 1; $numElements)
	$change{$i}:=PnP_DeliveryScheduleIsSame(aCPN{$i})
End for 

SORT ARRAY:C229($change; aCPN; >)
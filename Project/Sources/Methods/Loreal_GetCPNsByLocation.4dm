//%attributes = {}
// -------
// Method: Loreal_GetCPNsByLocation   ( ) ->
// By: Mel Bohince @ 08/31/16, 13:32:35
// Description
// based on: PnG_GetCPNsByLocation (address id) -> 
// ----------------------------------------------------
// by: mel: 06/17/05, 16:53:57
// ----------------------------------------------------
// Description:
// get all the cpns in an array for a given location
// ----------------------------------------------------

C_TEXT:C284($1)
C_TEXT:C284($destQry; $relQry; $0)

$relQry:="@"
If (Count parameters:C259=0)
	$destQry:="@"
	$0:="Lorea"
	
Else 
	If ($1#"Lorea")
		$destQry:=$1  //Substring($1;1;3)
		$destQry:=txt_Trim($destQry)
		$0:=$destQry
	Else 
		$destQry:="@"
		$0:="Lorea"
	End if 
End if 

//get PnG's schedule
ARRAY TEXT:C222(aCPN; 0)
QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ShipTo:8=$destQry; *)
QUERY:C277([Finished_Goods_DeliveryForcasts:145];  & ; [Finished_Goods_DeliveryForcasts:145]Custid:12="00765")
DISTINCT VALUES:C339([Finished_Goods_DeliveryForcasts:145]ProductCode:2; aCPN)
$numElements:=Size of array:C274(aCPN)
//get the Arkay schedule
ARRAY TEXT:C222($relCPN; 0)
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12="00765"; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Shipto:10=$relQry; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]ProductCode:11; $relCPN)

//For ($i;1;Size of array($relCPN))
//If (Length($relCPN{$i})>0)
//$hit:=Find in array(aCPN;$relCPN{$i})
//If ($hit=-1)
//$numElements:=$numElements+1
//ARRAY TEXT(aCPN;$numElements)
//aCPN{$numElements}:=$relCPN{$i}
//End if 
//End if 
//End for 
SORT ARRAY:C229(aCPN; >)

$numElements:=Size of array:C274(aCPN)
ARRAY LONGINT:C221($change; $numElements)
For ($i; 1; $numElements)
	$change{$i}:=PnP_DeliveryScheduleIsSame(aCPN{$i})
End for 
SORT ARRAY:C229($change; aCPN; >)
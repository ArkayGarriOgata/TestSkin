//%attributes = {"publishedWeb":true}
//PM: Pjt_PickFromList() -> 
//@author mlb - 6/29/01  12:45
// Modified by: Mel Bohince (8/18/21)  [Customers_Projects];"PickOne" replaced with util_PickOne_UI

C_TEXT:C284($1; $0; $custid; $rtnValue)

If (Count parameters:C259=1)
	$custid:=$1
Else 
	$custid:="@"  //"01860"//
End if 

$thePick:=util_PickOne_UI(ds:C1482.Customers_Projects.query("Customerid = :1"; $custid); "Name"; ->[Customers_Projects:9])
If ($thePick.success)
	$rtnValue:=[Customers_Projects:9]id:1
	UNLOAD RECORD:C212([Customers_Projects:9])
Else 
	$rtnValue:=""
End if 

$0:=$rtnValue

// Modified by: Mel Bohince (8/18/21)  replaced iwth util_PickOne_UI
//READ ONLY([Customers_Projects])
//QUERY([Customers_Projects];[Customers_Projects]Customerid=$custid)
//If (Records in selection([Customers_Projects])>0)
//ARRAY TEXT($aPjtNum;0)
//ARRAY TEXT(asDesc1;0)
//SELECTION TO ARRAY([Customers_Projects]id;$aPjtNum;[Customers_Projects]Name;asDesc1)
//SORT ARRAY(asDesc1;$aPjtNum;>)
//zwStatusMsg ("PROJECT";"Select a project for estimate "+[Estimates]EstimateNo)
//$winRef:=Open form window([Customers_Projects];"PickOne";5;Horizontally centered;Vertically centered)
//DIALOG([Customers_Projects];"PickOne")
//CLOSE WINDOW  //($winRef)
//If (ok=1)
//$0:=$aPjtNum{asDesc1}
//Else 
//$0:=""
//End if 

//REDUCE SELECTION([Customers_Projects];0)
//Else 
//$0:=""
//End if 
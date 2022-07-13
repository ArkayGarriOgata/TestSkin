//%attributes = {}
// _______
// Method: FGL_findBySkid   ( ) ->
// By: Mel Bohince @ 08/29/19, 17:12:22
// Description
// load a FGL record based on skid number
// ----------------------------------------------------
C_TEXT:C284($skid; $1; $2)
$skid:=$1
C_LONGINT:C283($numLocations; $0)
//dialog varibles:
If (Count parameters:C259=2)  //reset requested
	sCriterion1:=""
	sCriterion2:=""
	sCriterion3:=""  //will be set by the Move btn
	sCriterion4:=""  //will be set by the Move btn
	sCriterion5:=""
	sCriterion6:=""
	i1:=0
	rReal1:=0
	sJobit:=""
End if 

QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]skid_number:43=$skid)
$numLocations:=Records in selection:C76([Finished_Goods_Locations:35])
Case of 
	: ($numLocations=1)
		sCriterion1:=[Finished_Goods_Locations:35]ProductCode:1
		sCriterion2:=[Finished_Goods_Locations:35]CustID:16
		ARRAY TEXT:C222(asFrom; 0)
		ARRAY TEXT:C222(asFrom; 1)
		asFrom{1}:=[Finished_Goods_Locations:35]Location:2
		asFrom{0}:=asFrom{1}
		sCriterion3:=asFrom{0}  //from
		sCriterion5:=Substring:C12([Finished_Goods_Locations:35]Jobit:33; 1; 8)
		i1:=Num:C11(Substring:C12([Finished_Goods_Locations:35]Jobit:33; 10; 2))  //12345.78.01
		rReal1:=[Finished_Goods_Locations:35]QtyOH:9
		sJobit:=[Finished_Goods_Locations:35]Jobit:33
		
	: ($numLocations>1)
		sCriterion1:=[Finished_Goods_Locations:35]ProductCode:1
		sCriterion2:=[Finished_Goods_Locations:35]CustID:16
		//from, user needs to select
		ARRAY TEXT:C222(asFrom; 0)
		SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Location:2; asFrom)
		asFrom{0}:=asFrom{1}
		sCriterion3:=asFrom{0}
		sCriterion5:=Substring:C12([Finished_Goods_Locations:35]Jobit:33; 1; 8)
		i1:=Num:C11(Substring:C12([Finished_Goods_Locations:35]Jobit:33; 10; 2))  //12345.78.01
		rReal1:=[Finished_Goods_Locations:35]QtyOH:9
		sJobit:=[Finished_Goods_Locations:35]Jobit:33
		
	Else 
		uConfirm("Skid# "+$skid+" was not found in any locations, please try again."; "Ok"; "Help")
End case 

If (Length:C16(sJobit)>0)
	$numRecs:=qryJMI(sJobit)
	If ($numRecs>0)  //5/4/95 
		sCriterion6:=[Job_Forms_Items:44]OrderItem:2
		UNLOAD RECORD:C212([Job_Forms_Items:44])
	End if 
End if 

$0:=$numLocations
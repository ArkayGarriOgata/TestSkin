//%attributes = {}

// Method: PSG_History ( {cpn})  -> costcenter_id
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/04/14, 11:32:29
// ----------------------------------------------------
// Description
// find the last(s) costcenter to glue this product code
//
// ----------------------------------------------------
// Modified by: Mel Bohince (5/6/15)  read only and reduce

C_TEXT:C284($cpn; $1; $outline; $2)
C_TEXT:C284($0)

If (Count parameters:C259=1)
	$cpn:=$1
Else 
	$cpn:=[Job_Forms_Items:44]ProductCode:3
End if 

$0:="n/f"  //always the pesimist
READ ONLY:C145([Job_Forms_Items:44])  // Modified by: Mel Bohince (5/6/15) 

If (Count parameters:C259<2)
	//find the jobits that produced this product code
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=$cpn)
	If (Records in selection:C76([Job_Forms_Items:44])>0)
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]Jobit:4; $aJobits)
		QUERY WITH ARRAY:C644([Job_Forms_Machine_Tickets:61]Jobit:23; $aJobits)
		
		If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
			SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]CostCenterID:2; $aMTcostcenters; [Job_Forms_Machine_Tickets:61]DateEntered:5; $aMTdates)
			SORT ARRAY:C229($aMTdates; $aMTcostcenters; <)
			$0:=$aMTcostcenters{1}
		End if 
	End if 
	
Else   //by outline#
	$outline:=$2
	//find the jobits that produced this product code
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]OutlineNumber:43=$outline)
	If (Records in selection:C76([Job_Forms_Items:44])>0)
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]Jobit:4; $aJobits)
		QUERY WITH ARRAY:C644([Job_Forms_Machine_Tickets:61]Jobit:23; $aJobits)
		
		If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
			SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]CostCenterID:2; $aMTcostcenters; [Job_Forms_Machine_Tickets:61]DateEntered:5; $aMTdates)
			SORT ARRAY:C229($aMTdates; $aMTcostcenters; <)
			$0:=$aMTcostcenters{1}
		End if 
	End if 
End if 

If ($0#"n/f")
	
End if 

REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)  // Modified by: Mel Bohince (5/6/15) 
//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 07/11/07, 09:12:48
// ----------------------------------------------------
// Method: JMI_TestForValue(jobit)->bool
// Description
// apply business rule for fg not tagged as obsolete and not over 9 mths old
// ----------------------------------------------------
// Modified by: Mel Bohince (5/15/14) don't move fg cursor if not necessary because when looping in THC_request_update the f/g is current and should remain so

C_BOOLEAN:C305($value; $0)

$value:=True:C214

If ([Job_Forms_Items:44]Jobit:4#$1)
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4=$1)
End if 

If ([Finished_Goods:26]FG_KEY:47#([Job_Forms_Items:44]CustId:15+":"+[Job_Forms_Items:44]ProductCode:3))  // Modified by: Mel Bohince (5/15/14) don't move fg cursor if not necessary
	$numFG:=qryFinishedGood([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
Else 
	$numFG:=1
End if 

If ($numFG>0)
	If (Position:C15("obsolete"; [Finished_Goods:26]Status:14)>0)  //test status
		If ([Finished_Goods:26]FRCST_NumberOfReleases:69=0)
			$value:=False:C215
		End if 
	End if 
	
	If ($value)  //test age
		If ([Job_Forms_Items:44]Glued:33#!00-00-00!)
			$nineMths:=Add to date:C393(4D_Current_date; 0; -9; 0)
			If ([Job_Forms_Items:44]Glued:33<$nineMths)
				$value:=False:C215
			End if 
		End if 
	End if 
Else 
	$value:=False:C215
End if 

$0:=$value
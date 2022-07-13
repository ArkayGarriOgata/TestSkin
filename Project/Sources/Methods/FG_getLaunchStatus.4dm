//%attributes = {}
// _______
// Method: FG_getLaunchStatus   ( cpn ) -> txt:status
// By: Mel Bohince @ 06/24/20, 14:22:13
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (7/18/20) option to turn off in Release_UI

C_TEXT:C284($cpn; $1; $0; $2)

If (Count parameters:C259>0)
	$cpn:=$1
Else 
	$cpn:="SKJM-01-A112"
End if 

C_OBJECT:C1216($fg_es)
If (showLaunchDetails) | (Count parameters:C259=2)  // Modified by: Mel Bohince (7/18/20) turn on or off in Release_UI
	//$fg_es:=ds.FINISHED_GOODS.query("ProductCode = :1 ";$cpn)
	$fg_es:=ds:C1482.Finished_Goods.query("ProductCode = :1 and OriginalOrRepeat = :2 and DateLaunchReceived # :3"; $cpn; "Original"; !00-00-00!)
	If ($fg_es.length>0)
		
		Case of 
			: ($fg_es[0].DateLaunchApproved#!00-00-00!)
				$0:="OK"
				
			: ($fg_es[0].DateLaunchSubmitted#!00-00-00!)
				$0:="Waiting"
				
			Else 
				$0:="Samples"
		End case 
		
		
		
		//$launchDates:=New object(\
			"Received";String($fg_es[0].DateLaunchReceived;Internal date short special);\
			"Submitted";String($fg_es[0].DateLaunchSubmitted;Internal date short special);\
			"Approved";String($fg_es[0].DateLaunchApproved;Internal date short special))
		
	Else   //not a launch item
		//$launchDates:=Null
		$0:=""
	End if 
	
Else 
	$0:="Off"
End if 


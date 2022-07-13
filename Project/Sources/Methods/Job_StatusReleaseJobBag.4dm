//%attributes = {"publishedWeb":true}
//PM:  Job_StatusReleaseJobBagobform;{date})  2/16/01  mlb
//planner says its ok to produce now

C_TEXT:C284($1)
C_DATE:C307($date; $2)

If ([Job_Forms:42]JobFormID:5#$1)
	READ WRITE:C146([Job_Forms:42])
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$1)
End if 

If ([Job_Forms_Master_Schedule:67]JobForm:4#$1)
	READ WRITE:C146([Job_Forms_Master_Schedule:67])
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms:42]JobFormID:5=$1)
End if 

$failed:=Job_Bag_Validate
If (Not:C34($failed))
	If (Count parameters:C259=2)
		$date:=$2
	Else 
		$date:=4D_Current_date
	End if 
	
	If (Records in selection:C76([Job_Forms:42])>0)
		Case of 
			: ([Job_Forms:42]Status:6="c@")  //close or complet
				//do nothing        
			: ([Job_Forms:42]Status:6="wip")  //shouldn't hit
				[Job_Forms:42]PlnnerReleased:59:=$date
				SAVE RECORD:C53([Job_Forms:42])
			Else 
				[Job_Forms:42]Status:6:="Released"
				[Job_Forms:42]PlnnerReleased:59:=$date
				SAVE RECORD:C53([Job_Forms:42])
		End case 
	End if 
	
	If (Records in selection:C76([Job_Forms_Master_Schedule:67])=1)
		If ([Job_Forms_Master_Schedule:67]PlannerReleased:14=!00-00-00!)
			[Job_Forms_Master_Schedule:67]PlannerReleased:14:=[Job_Forms:42]PlnnerReleased:59
			SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
		End if 
	End if 
	
Else 
	ALERT:C41("Can't release this job until these matters are cleared up."; "Dag nab it")
	[Job_Forms:42]Status:6:=Old:C35([Job_Forms:42]Status:6)
	[Job_Forms_Master_Schedule:67]PlannerReleased:14:=Old:C35([Job_Forms_Master_Schedule:67]PlannerReleased:14)
End if 
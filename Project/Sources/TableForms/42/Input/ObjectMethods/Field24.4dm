// _______
// Method: [Job_Forms].Input.Status   ( ) ->
// Modified by: Mel Bohince (4/28/21) Hold status removes plannersrelease date


If (fJOrderRules4(Old:C35([Job_Forms:42]Status:6); [Job_Forms:42]Status:6))
	
	Case of 
		: ([Job_Forms:42]Status:6="WIP")
			If ([Job_Forms:42]StartDate:10=!00-00-00!)
				[Job_Forms:42]StartDate:10:=4D_Current_date
			End if 
			
		: ([Job_Forms:42]Status:6="Released")
			Job_StatusReleaseJobBag([Job_Forms:42]JobFormID:5)
			
		: ([Job_Forms:42]Status:6="Complete")
			BEEP:C151
			ALERT:C41("Must set the Complete on Job Master Log or Completed button on Job palette.")
			[Job_Forms:42]Status:6:=Old:C35([Job_Forms:42]Status:6)
			
		: ([Job_Forms:42]Status:6="Closed")
			If ([Job_Forms:42]ClosedDate:11=!00-00-00!)
				[Job_Forms:42]ClosedDate:11:=4D_Current_date
			End if 
			If ([Job_Forms:42]Completed:18=!00-00-00!)
				[Job_Forms:42]Completed:18:=[Job_Forms:42]ClosedDate:11
			End if 
			
		: ([Job_Forms:42]Status:6="Kill")
			If ([Job_Forms:42]ClosedDate:11=!00-00-00!)
				[Job_Forms:42]ClosedDate:11:=4D_Current_date
			End if 
			If ([Job_Forms:42]Completed:18=!00-00-00!)
				[Job_Forms:42]Completed:18:=[Job_Forms:42]ClosedDate:11
			End if 
			
	End case 
	
	If (Position:C15("Hold"; [Job_Forms:42]Status:6)#0)
		Core_ObjectSetColor(->[Job_Forms:42]Status:6; -(3+(256*0)))
		[Job_Forms:42]PlnnerReleased:59:=!00-00-00!  // Modified by: Mel Bohince (4/28/21) 
		
	Else 
		Core_ObjectSetColor(->[Job_Forms:42]Status:6; -(15+(256*0)))
	End if 
	
Else 
	[Job_Forms:42]Status:6:=Old:C35([Job_Forms:42]Status:6)
End if 
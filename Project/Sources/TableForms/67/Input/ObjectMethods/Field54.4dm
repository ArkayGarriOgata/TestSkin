//mlb 060898 connect to vf
//mlb 061098 set seqs in vf to final reviewed
//• 8/5/98 cs do not change status if closed
//•120998  MLB Y2K Remediation 

//If (JML_CanThisJobBeMarkedComplete )
C_LONGINT:C283($err)
$err:=sDateLimitor(Self:C308; 7; 7)

If ([Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!)
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]DateComplete:15; -(14+(256*12)))  //grey
	If (Old:C35([Job_Forms_Master_Schedule:67]DateComplete:15)#!00-00-00!)
		JML_UnComplete
	End if 
	
Else 
	If (Job_RnD_ResultsProvided([Job_Forms_Master_Schedule:67]JobForm:4))  // Modified by: Mel Bohince (4/1/16) 
		Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]DateComplete:15; -(15+(256*12)))  //  
		If ([Job_Forms_Master_Schedule:67]GoalMetOn:62=!00-00-00!)
			[Job_Forms_Master_Schedule:67]GoalMetOn:62:=[Job_Forms_Master_Schedule:67]DateComplete:15
		End if 
		
	Else 
		uConfirm("R & D Tests/Results on tab 4 of jobform need to be entered before Completing job!"; "Ok"; "Cancel")
		[Job_Forms_Master_Schedule:67]DateComplete:15:=!00-00-00!
	End if 
End if   //not 0/0/0  

//Else 
//uConfirm ("All items haven't been glued by Rama yet. Can't set complete date.";"OK";"Help")
//[Job_Forms_Master_Schedule]DateComplete:=Old([Job_Forms_Master_Schedule]DateComplete)
//End if 
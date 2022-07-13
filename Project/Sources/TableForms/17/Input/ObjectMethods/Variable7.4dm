// ----------------------------------------------------
// User name (OS): work
// Date and time: 09/26/06, 12:36:08
// ----------------------------------------------------
// Object Method: Object Method: bReviseJob
// SetObjectProperties, Mark Zinke (5/15/13)
// ----------------------------------------------------

If (Records in selection:C76([Estimates_Differentials:38])=1)
	CREATE SET:C116([Estimates_Differentials:38]; "clickedIncludeRecordDIFF")
End if 

Case of 
	: ([Estimates:17]JobNo:50#0) & (iMode=3)  //Review the job
		READ ONLY:C145([Jobs:15])
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=[Estimates:17]JobNo:50)
			pattern_PassThru(->[Jobs:15])
			REDUCE SELECTION:C351([Jobs:15]; 0)
			
		Else 
			
			SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
			QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=[Estimates:17]JobNo:50)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
			$filePtr:=->[Jobs:15]
			<>PassThrough:=True:C214
			
			If (Records in selection:C76([Jobs:15])>0)
				
				REDUCE SELECTION:C351([Jobs:15]; 0)
				
			End if 
			
		End if   // END 4D Professional Services : January 2019 
		
		ViewSetter(3; ->[Jobs:15])
		
	: (Not:C34(User in group:C338(Current user:C182; "Planners")))  //acl'd
		uConfirm("Only Planners may Create and Revise jobs."; "OK"; "Help")
		
	: (Records in set:C195("clickedIncludeRecordDIFF")#1)  //pick a diff
		uConfirm("Click on ONE Differential to use for the Job Revision."; "OK"; "Help")
		
	Else 
		CUT NAMED SELECTION:C334([Estimates_Differentials:38]; "holdWhileMakingJob")
		
		USE SET:C118("clickedIncludeRecordDIFF")
		
		$diff:=[Estimates_Differentials:38]diffNum:3
		
		If ([Estimates_Differentials:38]TotalPieces:8=0) | ([Estimates_Differentials:38]CostTTL:14=0)  //not yet calc'd
			bAddPlate:=0
			bTrates:=0
			Est_Calculate
		End if 
		
		If ([Estimates_Differentials:38]TotalPieces:8>0)  //no error during calc
			USE NAMED SELECTION:C332("holdWhileMakingJob")
			HIGHLIGHT RECORDS:C656("clickedIncludeRecordDIFF")
			
			If ([Estimates:17]JobNo:50=0)  //create a job
				wWindowTitle("push"; "Creating Job "+String:C10([Estimates:17]JobNo:50))
				<>jobform:=String:C10(JOB_PlanJob([Estimates:17]Cust_ID:2; [Estimates:17]Brand:3; 0; [Estimates:17]EstimateNo:1; $diff))
				If ([Estimates:17]JobNo:50=0)
					SetObjectProperties(""; ->bReviseJob; True:C214; "Create Job")
				Else 
					SetObjectProperties(""; ->bReviseJob; True:C214; "Revise Job")
				End if 
				
			Else   //revision
				wWindowTitle("push"; "Revising Job "+String:C10([Estimates:17]JobNo:50))
				JOB_ReviseExisting2([Estimates:17]EstimateNo:1; $diff)  //• 7/23/98 cs new method to stop
			End if 
			
			wWindowTitle("pop")
			
		Else 
			uConfirm("There was an error during the Calculation that must be fixed before making the budget."; "OK"; "Help")
		End if 
		
End case 
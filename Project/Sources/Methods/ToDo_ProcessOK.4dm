//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 01/25/06, 13:08:26
// ----------------------------------------------------
// Method: ToDo_ProcessOK
// Description
// make sure that there is an "OK" record for each operation on the job
//
// Parameters
//[Machine_Job] record must be loaded first
// ----------------------------------------------------

If (Length:C16([Job_Forms_Machines:43]JobForm:1)=8)  //[Machine_Job] record must be loaded first
	If (Position:C15([Job_Forms_Machines:43]CostCenterID:4; " 888 ")=0)
		$jobSeq:=[Job_Forms_Machines:43]JobForm:1+"."+String:C10([Job_Forms_Machines:43]Sequence:5; "000")
		QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]Jobform:1=$jobSeq)
		If (Records in selection:C76([To_Do_Tasks:100])=0)
			CREATE RECORD:C68([To_Do_Tasks:100])
			[To_Do_Tasks:100]Jobform:1:=$jobSeq
			[To_Do_Tasks:100]Category:2:="Job Bag OK?"
			[To_Do_Tasks:100]Critical:11:=True:C214
			[To_Do_Tasks:100]PjtNumber:5:=pjtId
		End if 
		//clear out if this is a revision
		[To_Do_Tasks:100]Task:3:=[Job_Forms_Machines:43]CostCenterID:4+" Ready to Proceed on seq "+String:C10([Job_Forms_Machines:43]Sequence:5; "000")
		[To_Do_Tasks:100]AssignedTo:9:=ToDo_setAssignedTo([Job_Forms_Machines:43]CostCenterID:4)
		[To_Do_Tasks:100]CreatedBy:8:=<>zResp
		[To_Do_Tasks:100]DateDone:6:=!00-00-00!
		//[ToDo_for_Jobs]DateDue:=` set by JML_setPressDatefromSched
		[To_Do_Tasks:100]Done:4:=False:C215
		[To_Do_Tasks:100]DoneBy:7:=""
		SAVE RECORD:C53([To_Do_Tasks:100])
		UNLOAD RECORD:C212([To_Do_Tasks:100])
	End if 
End if 
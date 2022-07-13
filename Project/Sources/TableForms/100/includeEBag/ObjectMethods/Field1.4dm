$continue:=True:C214
If (Length:C16([To_Do_Tasks:100]AssignedTo:9)>0)
	Case of 
		: ([To_Do_Tasks:100]CreatedBy:8=<>zResp)
			
		: ([To_Do_Tasks:100]AssignedTo:9=<>zResp)
			
		: ([To_Do_Tasks:100]AssignedTo:9=Current user:C182)
			
		: (User in group:C338(Current user:C182; [To_Do_Tasks:100]AssignedTo:9))
			
		Else 
			uConfirm("Did you complete this for "+[To_Do_Tasks:100]AssignedTo:9; "Yes"; "Cancel")
			If (ok=0)
				$continue:=False:C215
			End if 
	End case 
End if 

If ($continue)
	If ([To_Do_Tasks:100]Done:4)
		[To_Do_Tasks:100]DateDone:6:=4D_Current_date
		[To_Do_Tasks:100]DoneBy:7:=<>zResp
	Else 
		[To_Do_Tasks:100]DateDone:6:=!00-00-00!
		[To_Do_Tasks:100]DoneBy:7:=""
	End if 
	SAVE RECORD:C53([To_Do_Tasks:100])
	
Else 
	[To_Do_Tasks:100]Done:4:=Old:C35([To_Do_Tasks:100]Done:4)
	BEEP:C151
	ALERT:C41("You are not authorized to check-off this task.")
End if 
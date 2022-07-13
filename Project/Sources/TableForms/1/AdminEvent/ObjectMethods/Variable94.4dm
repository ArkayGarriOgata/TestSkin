If (Current user:C182="Designer")
	BEEP:C151
	CONFIRM:C162("Have you made a backup?"; "Yes, Continue"; "ABORT")
	If (OK=1)
		ams_PurgeBtn
		
		//doPurgeChk4Hole 
		//
		//CONFIRM("Last chance, have you made a backup?";"Yes, Continue";"ABORT")
		//If (OK=1)
		//$pid:=Execute on server("ams_Purge_Server_Side";128*1024;"aMs Purge")
		//If (False)
		//ams_Purge_Server_Side //was ams_PurgeUI
		//End if 
		//End if 
		//
		//  //If (False)
		//  //doPurge   //old way 
		//  //End if 
		//End if 
		
	Else 
		BEEP:C151
		CONFIRM:C162("Check for holes?"; "Yes"; "No")
		If (OK=1)
			doPurgeChk4Hole
		End if 
	End if 
	
End if 
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Object Method: AdvancedScheduler.Column3 - Created `v1.0.0-PJK (12/16/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($xlCol; $i; $xlRow)
C_TEXT:C284($ttMainRef; $ttMachine)

If (Form event code:C388=On Clicked:K2:4)
	LISTBOX GET CELL POSITION:C971(lbJobs; $xlCol; $xlRow)
	If ($xlRow>0)
		
		If (Macintosh option down:C545)
			$ttMachine:="All"
		Else 
			$ttMachine:=sttJobMachineID{$xlRow}
		End if 
		
		$ttMachineID:=SelectCostCenterPopup($ttMachine)
		If ($ttMachineID#"")
			If (Adv_ScheduleToMachine($ttMachineID; sttJobFormSeq{$xlRow}))
				// Successfully scheduled to machine schedule
				//Update item in list
				
				Adv_JobSchedulerArrays("Update"; ->$xlRow)
				
			End if 
		End if 
		
	End if 
	
	
	
	
	
End if 


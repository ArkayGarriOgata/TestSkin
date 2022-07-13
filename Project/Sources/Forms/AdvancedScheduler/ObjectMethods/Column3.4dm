//© 2015 Footprints Inc. All Rights Reserved.
//Method: Object Method: AdvancedScheduler.Column3 - Created `v1.0.0-PJK (12/16/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($xlCol; $i; $xlRow)
C_TEXT:C284($ttMainRef; $ttMachine; $ttOperation; $ttProcessName; ttGotoOperationID)

If (Form event code:C388=On Clicked:K2:4)
	LISTBOX GET CELL POSITION:C971(lbJobs; $xlCol; $xlRow)
	If ($xlRow>0)
		//QUERY([Cost_Centers];[Cost_Centers]ID=sttJobOnMachineID{$xlRow})
		$ttMachine:=sttJobOnMachineID{$xlRow}
		$ttOperation:=sttJobFormSeq{$xlRow}
		
		If ($ttMachine#"")
			$ttProcessName:=$ttMachine+" Schedule"
			$xlPID:=Process number:C372($ttProcessName)
			If ($xlPID>0)
				BRING TO FRONT:C326($xlPID)
				SET PROCESS VARIABLE:C370($xlPID; ttGotoOperationID; $ttOperation)
				POST OUTSIDE CALL:C329($xlPID)
			Else 
				$xlPID:=New process:C317("PS_PressSchedule"; <>lMidMemPart; $ttProcessName; $ttMachine; $ttOperation)
			End if 
			
		End if 
	End if 
	
End if 

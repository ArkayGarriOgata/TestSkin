// Method: [zz_control].FGTranfers.Last3 "JobItemComplete"
//------------------------------------------------
// Modified by: Mel Bohince (12/11/15) remove option to "un" complete so subforms can be set

READ WRITE:C146([Job_Forms_Items:44])
$numJMI:=qryJMI(sCriterion5; i1)
If ($numJMI>0)
	//If ([Job_Forms_Items]Completed=!00/00/0000!)
	uConfirm("Click Continue if you want to mark "+[Job_Forms_Items:44]Jobit:4+" as complete."; "Continue"; "Cancel")
	//Else 
	//CONFIRM("Click Continue if you want to mark "+[Job_Forms_Items]Jobit+" as NOT complete.";"Continue";"Cancel")
	//End if 
	
	If (ok=1)
		For ($i; 1; $numJMI)
			If (fLockNLoad(->[Job_Forms_Items:44]))
				If ([Job_Forms_Items:44]Completed:39=!00-00-00!)
					[Job_Forms_Items:44]Completed:39:=4D_Current_date
					[Job_Forms_Items:44]CasePackUsed:45:=PK_getCaseCount([Job_Forms_Items:44]OutlineNumber:43)
					SAVE RECORD:C53([Job_Forms_Items:44])
				Else 
					uConfirm("Remove the Completed date on this Job item?"; "Leave"; "Remove")
					If (ok=0)
						[Job_Forms_Items:44]Completed:39:=!00-00-00!
						SAVE RECORD:C53([Job_Forms_Items:44])
					End if 
					
				End if 
			End if 
			NEXT RECORD:C51([Job_Forms_Items:44])
		End for 
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
			
			UNLOAD RECORD:C212([Job_Forms_Items:44])
			
		Else 
			
			// you have next record 30
			
		End if   // END 4D Professional Services : January 2019 
		
		//Case of 
		//: ($numJMI=1)
		//If ([Job_Forms_Items]Completed=!00/00/0000!)
		//[Job_Forms_Items]Completed:=4D_Current_date
		//[Job_Forms_Items]CasePackUsed:=PK_getCaseCount ([Job_Forms_Items]OutlineNumber)
		//SAVE RECORD([Job_Forms_Items])
		//Else 
		//CONFIRM("Remove the Completed date on this Job item?")
		//If (ok=1)
		//[Job_Forms_Items]Completed:=!00/00/0000!
		//SAVE RECORD([Job_Forms_Items])
		//End if 
		
		//End if 
		
		
		//: ($numJMI>1)
		
		
		//If ([Job_Forms_Items]Completed=!00/00/0000!)
		//APPLY TO SELECTION([Job_Forms_Items];[Job_Forms_Items]Completed:=4D_Current_date)
		//FIRST RECORD([Job_Forms_Items])
		//APPLY TO SELECTION([Job_Forms_Items];[Job_Forms_Items]CasePackUsed:=PK_getCaseCount ([Job_Forms_Items]OutlineNumber))
		//Else 
		//CONFIRM("Remove the Completed dates on this Job item?")
		//If (ok=1)
		//APPLY TO SELECTION([Job_Forms_Items];[Job_Forms_Items]Completed:=!00/00/0000!)
		//End if 
		//End if 
		//End case 
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("Enter the job form and item number first.")
End if 

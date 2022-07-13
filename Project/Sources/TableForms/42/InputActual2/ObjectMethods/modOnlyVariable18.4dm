//(S) bCalc

If (Not:C34(Read only state:C362([Job_Forms:42])))
	zwStatusMsg("Allocate Actuals"; "Please Wait...")
	wWindowTitle("Push"; "Jobform {actuals} Calculating "+[Job_Forms:42]JobFormID:5+" Please Wait...")
	
	jobform:=[Job_Forms:42]JobFormID:5
	zwStatusMsg("SERVER REQUEST"; "Allocate "+jobform)
	Job_ExecuteOnServer("client-prep"; "rollup"; jobform)
	zwStatusMsg("SERVER REQUEST"; "Waiting for "+jobform)
	fCalcAlloc:=Job_ExecuteOnServer("exchange")
	
	wWindowTitle("Pop")
	
	BEEP:C151
	zwStatusMsg("Allocate Actuals"; "Finished.")
	
Else 
	ALERT:C41("Cannot calculate ALLOCATION in Review mode!!!")
End if 
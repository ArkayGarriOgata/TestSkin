//(s) bCloseJob
//takes needed actions to close out a Job form/Job
//• 12/2/97 cs created
//uConfirm ("Calc locally or on server?";"Server";"Local")
//If (ok=0)
//COPY NAMED SELECTION([Job_Forms];"formlist")
//doJobCloseOut 
//USE NAMED SELECTION("formlist")
//CLEAR NAMED SELECTION("formlist")
//
//  `
//Else   `suspend the display until server finishes
//-----------rollup/allocate step //same as the Allocate Actuals button

If ([Job_Forms:42]Status:6="Closed")
	uConfirm("Job Form "+[Job_Forms:42]JobFormID:5+" has already been closed."+Char:C90(13)+"Are you sure you want to run the Close out routines again?"; "Again"; "Stop")
Else 
	OK:=1
End if 


If (OK=1)
	wWindowTitle("Push"; "Jobform {actuals} Calculating "+[Job_Forms:42]JobFormID:5+" Please Wait...")
	UNLOAD RECORD:C212([Jobs:15])
	
	jobform:=[Job_Forms:42]JobFormID:5
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		
		COPY NAMED SELECTION:C331([Job_Forms:42]; "JobformsBeforeClose")
		
	Else 
		
		ARRAY LONGINT:C221($_JobformsBeforeClose; 0)
		LONGINT ARRAY FROM SELECTION:C647([Job_Forms:42]; $_JobformsBeforeClose)
		
		
	End if   // END 4D Professional Services : January 2019 
	
	zwStatusMsg("SERVER REQUEST"; "Allocate "+jobform)
	Job_ExecuteOnServer("client-prep"; "rollup-close"; jobform)
	
	zwStatusMsg("SERVER REQUEST"; "Waiting for allocating "+jobform)
	fCalcAlloc:=Job_ExecuteOnServer("exchange")
	//-----------closeout step
	zwStatusMsg("SERVER REQUEST"; "Closing "+jobform)
	Job_ExecuteOnServer("client-prep"; "closeout"; jobform)
	
	zwStatusMsg("SERVER REQUEST"; "Waiting for closing "+jobform)
	fCalcAlloc:=Job_ExecuteOnServer("exchange")
	
	zwStatusMsg("CLOSE OUT"; "Beginning report for "+jobform)
	aJobNo:=jobform
	JOB_Closeout("S")
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		
		USE NAMED SELECTION:C332("JobformsBeforeClose")
		CLEAR NAMED SELECTION:C333("JobformsBeforeClose")
		
	Else 
		
		CREATE SELECTION FROM ARRAY:C640([Job_Forms:42]; $_JobformsBeforeClose)
		
	End if   // END 4D Professional Services : January 2019 
	
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms:42]JobFormID:5; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
	ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Commodity_Key:22; >; [Raw_Materials_Transactions:23]XferDate:3; >)
	COPY NAMED SELECTION:C331([Raw_Materials_Transactions:23]; "rmXfers")
	wWindowTitle("Pop")
	
	LOAD RECORD:C52([Jobs:15])
	
End if 

BEEP:C151
zwStatusMsg("CLOSE OUT"; "Finished at "+String:C10(Current time:C178; HH MM AM PM:K7:5))
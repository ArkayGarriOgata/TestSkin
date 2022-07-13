//%attributes = {"publishedWeb":true}
//PM:  JOB_NewJob  110899  mlb
//formerly  `doOpenJob2()   --JML   9/14/93
//This procedure is accessed by the <enter Job> button found in the Job
//palette.  It creates a new Job based on the Estimate number given.

C_LONGINT:C283($job)

uSetUp(1; 1)  //uEnterOrder()
gClearFlags
READ WRITE:C146(filePtr->)
MESSAGES OFF:C175
NewWindow(250; 230; 6; 5; "Create Job")
DIALOG:C40([zz_control:1]; "OpenJob")
CLOSE WINDOW:C154

If (OK=1)
	$i:=Find in array:C230(asBull; "•")
	$Case:=asCaseID{$i}
	If (($i=1) & (asDiff{1}="Preparatory"))  //preparatory Estimate
		BEEP:C151
		ALERT:C41("Preparatory Job.")
	Else 
		
		$job:=JOB_PlanJob([Estimates:17]Cust_ID:2; [Estimates:17]Brand:3; 0; sPONum; $case)  //create Job & Job Form Records
	End if 
	
	fLoop:=False:C215
	If (<>iMode<3)
		MODIFY RECORD:C57([Jobs:15]; *)
	End if 
End if   //if OK
MESSAGES ON:C181
uSetUp(0; 0)
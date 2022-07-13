//%attributes = {"publishedWeb":true}
//PM:  JOB_Completion  2/25/00  mlb
//mark a form as completed
//• mlb - 11/20/02  16:19 set GoalMetOn date

C_TEXT:C284($1)
C_BOOLEAN:C305($success; $loggedin)

If (Count parameters:C259=1)
	$id:=uSpawnProcess("JOB_Completion"; 64000; "Recording Job Completions"; True:C214; True:C214)
	If (False:C215)
		JOB_Completion
	End if 
	
Else 
	//$today:=4D_Current_date 
	//SET MENU BAR(<>DefaultMenu)
	//NewWindow (636;438;0;0;"Job Forms Completed")  //" Reporting")
	//READ WRITE([Job_Forms_Master_Schedule])
	//READ WRITE([Job_Forms])
	ALERT:C41("Dialog [Job_Forms];GroupComplete removed 05/05/21")
	//DIALOG([Job_Forms];"GroupComplete")
	//$PrintForm:=(cbPrint=1)
	
	//If (OK=1)
	//For ($i;1;Size of array(aRpt))  //*for each job, print jobclosout,waste and save jobclosesummary record.
	//If (aRpt{$i}="√")  //selected to be reported
	//JML_setJobComplete (aJFID{$i})
	//End if 
	//End for 
	//End if 
	
	//CLOSE WINDOW
	//uWinListCleanup 
End if 
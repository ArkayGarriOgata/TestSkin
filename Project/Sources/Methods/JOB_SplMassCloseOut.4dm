//%attributes = {"publishedWeb":true}
//PM:  Job_SplMassCloseOut  2/05/00  mlb
//close a bunch of jobs becauses the allockationtion wasn't 
//dependable in some cases

C_DATE:C307(vDFrom; vDTo)
C_TIME:C306(docRef)

MESSAGES OFF:C175

<>zResp:="MASS"
docRef:=?00:00:00?
uSetUp(1; 1)

<>fContinue:=True:C214
JCOInitVars
//TRACE
//QUERY([FG_Locations];[FG_Locations]Location="EX@";*)
//QUERY([FG_Locations]; | ;[FG_Locations]Location="CC@")
//uRelateSelect (->[JobForm]JobFormID;->[FG_Locations]JobForm)
//QUERY SELECTION([JobForm];[JobForm]Status="closed")

//reclose all jobs in inventory that were close after 8/3/99

If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	ALL RECORDS:C47([Finished_Goods_Locations:35])
	READ WRITE:C146([Job_Forms:42])
	//TRACE
	uRelateSelect(->[Job_Forms:42]JobFormID:5; ->[Finished_Goods_Locations:35]JobForm:19)
	//QUERY SELECTION([JobForm];[JobForm]Status="closed")
	QUERY SELECTION:C341([Job_Forms:42]; [Job_Forms:42]ClosedDate:11>=!1999-08-03!)
	
	CREATE SET:C116([Job_Forms:42]; "changed")
	
Else 
	
	ALL RECORDS:C47([Finished_Goods_Locations:35])
	
	READ WRITE:C146([Job_Forms:42])
	
	zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Job_Forms:42])+" file. Please Wait...")
	
	RELATE ONE SELECTION:C349([Finished_Goods_Locations:35]; [Job_Forms:42])
	
	QUERY SELECTION:C341([Job_Forms:42]; [Job_Forms:42]ClosedDate:11>=!1999-08-03!)
	
	zwStatusMsg(""; "")
	
	CREATE SET:C116([Job_Forms:42]; "changed")
	
End if   // END 4D Professional Services : January 2019 query selection

vTotRec:=Records in selection:C76([Job_Forms:42])
If (vTotRec>0)
	ON EVENT CALL:C190("eCancelPrint")
	SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; aJFID)  //*dump into an array for user selection
	SORT ARRAY:C229(aJFID)
	
	docRef:=Create document:C266("MassCloseOut"+String:C10(TSTimeStamp)+".txt")
	NewWindow(200; 40; 4; 8; "Job Spl Mass Close Out")  //" Reporting")
	$numJobs:=Size of array:C274(aJFID)
	For ($i; 1; $numJobs)  //*for each job, print jobclosout,waste and save jobclosesummary record.
		If (<>fContinue=False:C215)
			$i:=vTotRec  //get out of loop
		End if 
		utl_Trace
		zwStatusMsg("Close Out"; " Print close out for "+aJFID{$i})
		GOTO XY:C161(5; 1)
		MESSAGE:C88(aJFID{$i}+"  "+String:C10($i; "^^,^^^")+" of "+String:C10($numJobs))
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=aJFID{$i})
		RELATE MANY:C262([Job_Forms:42]JobFormID:5)  //get [JobMakesItem],[Material_Job],[MachineTicket],[RM_XFER]
		RELATE ONE:C42([Job_Forms:42])  // get the job header            
		aJobNo:=[Job_Forms:42]JobFormID:5  //setup for closeout repor
		JOB_RollupActuals
		JCOCloseForm
		JOB_AllocateActual
		JobCloseOut3rdPage("toDisk"; docRef)  //•1/25/00  mlb  enhance 3rd page
		
		If (<>fContinue=False:C215)
			$i:=Size of array:C274(aRpt)  //get out of loop
		End if 
	End for 
	CLOSE WINDOW:C154
	CLOSE DOCUMENT:C267(docRef)
	
	ON EVENT CALL:C190("")
	
	FLUSH CACHE:C297
	zwStatusMsg("Mass Closeout"; "Finished at "+TS2String(TSTimeStamp))
	BEEP:C151
	BEEP:C151
	BEEP:C151
	USE SET:C118("changed")
	CLEAR SET:C117("changed")
	
Else 
	BEEP:C151
	ALERT:C41("There are no Closed Jobs in that date range.")
End if 
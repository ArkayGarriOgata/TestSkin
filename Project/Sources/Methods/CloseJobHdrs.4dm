//%attributes = {"publishedWeb":true}
//Procedure: CloseJobHdrs()  031596  MLB
//set job status to "Closed" if all form have dateClosed
//print a report of what happened during this batch
//set up the job closeout analysis file  (FUTURE)
//•041996  MLB
//• 3/30/98 cs cleared out old comments
//•100599  mlb  ignor prep forms

C_TEXT:C284($CR)
C_TEXT:C284(xTitle; xText)
C_LONGINT:C283($i; $countJobs; $jobforms; $closed; $open; $hit)
C_DATE:C307($date)

$CR:=Char:C90(13)
$date:=4D_Current_date  //•041996  MLB  
//*Find all the candidate Orders, for now those are statii = Accepted & Budgeted
//*.                                                 but not Canceled,Delete, 
//*.                                                      Hold@,Kill,New,Opened
xTitle:="Job Close-out Summary for "+String:C10($date; <>LONGDATE)+"  "+String:C10(4d_Current_time; <>HMMAM)
xText:="____________________________________________"
READ ONLY:C145([Jobs:15])
ALL RECORDS:C47([Jobs:15])
xText:=xText+$CR+String:C10(Records in selection:C76([Jobs:15]); "^^^,^^^,^^0")+" Jobs in aMs."

READ WRITE:C146([Jobs:15])
QUERY:C277([Jobs:15]; [Jobs:15]Status:4#"Closed")
xText:=xText+$CR+String:C10(Records in selection:C76([Jobs:15]); "^^^,^^^,^^0")+" Unclosed Jobs."
xText:=xText+$CR+"____________________________________________"+$CR+"Closed:"+$CR
//*.   For each candidate, test the status of the forms
$countJobs:=Records in selection:C76([Jobs:15])
//$countJobs:=150
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	ORDER BY:C49([Jobs:15]; [Jobs:15]JobNo:1; >)
	FIRST RECORD:C50([Jobs:15])
	
	
Else 
	
	ORDER BY:C49([Jobs:15]; [Jobs:15]JobNo:1; >)
	
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  
$closed:=0  // number of orders closed this time
$jobforms:=0  //number of non-closed orderlines at this time.
$open:=0  //number of non-closed orders
//TRACE
MESSAGES OFF:C175
uThermoInit($countJobs; "Jobs Close-out Analysis")

For ($i; 1; $countJobs)
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobNo:2=[Jobs:15]JobNo:1; *)
	QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]JobFormID:5#(String:C10([Jobs:15]JobNo:1)+".00"))  //•100599  mlb  ignor prep forms
	If (Records in selection:C76([Job_Forms:42])>0)  //•041996  MLB skip job reservations
		ARRAY DATE:C224($aCloseDate; Records in selection:C76([Job_Forms:42]))  //• 3/30/98 cs declar array at correct size first time 
		SELECTION TO ARRAY:C260([Job_Forms:42]ClosedDate:11; $aCloseDate)
		$hit:=Find in array:C230($aCloseDate; !00-00-00!)  //look fo open jobs
		//SEARCH SELECTION([JobForm];[JobForm]ClosedDate=!00/00/00!)  `•041996  MLB  make 
		//*.        If all jobforms are closed, close the job and do the analysis
		
		If ($hit=-1)  //then all have a close date, so close the header
			[Jobs:15]LastStatus:16:=[Jobs:15]Status:4
			[Jobs:15]Status:4:="Closed"
			[Jobs:15]ModDate:8:=$date  //•071295  MLB  
			SORT ARRAY:C229($aCloseDate; <)
			[Jobs:15]CloseDate:17:=$aCloseDate{1}
			SAVE RECORD:C53([Jobs:15])
			xText:=xText+String:C10([Jobs:15]JobNo:1; "00000")+" "
			$closed:=$closed+1
		Else 
			$open:=$open+1
			$jobforms:=$jobforms+Records in selection:C76([Job_Forms:42])
		End if 
	End if 
	NEXT RECORD:C51([Jobs:15])
	uThermoUpdate($i)
End for 

uThermoClose

READ WRITE:C146([Job_Forms:42])
QUERY:C277([Job_Forms:42]; [Job_Forms:42]ClosedDate:11#!00-00-00!; *)
QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]StartDate:10=!00-00-00!)
APPLY TO SELECTION:C70([Job_Forms:42]; [Job_Forms:42]StartDate:10:=[Job_Forms:42]ClosedDate:11)
xText:=xText+$CR+"____________________________________________"
xText:=xText+$CR+String:C10($closed; "^^^,^^^,^^0")+" Jobs closed in this batch."
xText:=xText+$CR+String:C10($open; "^^^,^^^,^^0")+" Candidate Jobs are not closed."
xText:=xText+$CR+String:C10($jobforms; "^^^,^^^,^^0")+" JobForms are not closed."
xText:=xText+$CR+"_______________ END OF REPORT ______________"
//*Print a list of what happened on this run
QM_Sender(xTitle; ""; xText; "mel.bohince@arkay.com")
//rPrintText ("JOB_CLOSEOUT_"+fYYMMDD (4D_Current_date)+"_"+Replace 
//«string(String(4d_Current_time;◊HHMM);":";"")+".LOG")
xTitle:=""
xText:=""

ARRAY DATE:C224($aCloseDate; 0)
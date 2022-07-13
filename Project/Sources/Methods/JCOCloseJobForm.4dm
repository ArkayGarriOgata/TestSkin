//%attributes = {"publishedWeb":true}
//(p) JCOCloseJobform
//closes the Jobform, and looks to close the Job too
//• 12/4/97 cs created
//•120398  MLB  offer to retain close date
//print closeout report for form
// Modified by Mel Bohince on 3/27/07 at 14:49:46 : chg query dest

C_LONGINT:C283($numberOfForms; $numberClosed)

SET QUERY DESTINATION:C396(Into variable:K19:4; $numberOfForms)
QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobNo:2=[Job_Forms:42]JobNo:2)
SET QUERY DESTINATION:C396(Into variable:K19:4; $numberClosed)
QUERY SELECTION:C341([Job_Forms:42]; [Job_Forms:42]ClosedDate:11#!00-00-00!)
SET QUERY DESTINATION:C396(Into current selection:K19:1)  //restore query dest

If ($numberOfForms=$numberClosed)  //close job too  
	UNLOAD RECORD:C212([Jobs:15])
	READ WRITE:C146([Jobs:15])
	RELATE ONE:C42([Job_Forms:42]JobNo:2)
	
	If (fLockNLoad(->[Jobs:15]))  //why is this often locked?, picked up by the batch anyway
		[Jobs:15]LastStatus:16:=[Jobs:15]Status:4
		[Jobs:15]Status:4:="Closed"
		[Jobs:15]ModDate:8:=4D_Current_date
		[Jobs:15]ModWho:9:=<>zResp
		[Jobs:15]CloseDate:17:=4D_Current_date
		
		SAVE RECORD:C53([Jobs:15])
	Else 
		utl_Logfile("JobCloseOut.Log"; String:C10([Jobs:15]JobNo:1)+" JCOCloseJobForm frustrated")
	End if 
	REDUCE SELECTION:C351([Jobs:15]; 0)
	
End if 
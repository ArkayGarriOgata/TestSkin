//Script: bBatch
//TJF   040596

//MESSAGES OFF
READ WRITE:C146([Job_Forms:42])
Case of 
	: (rb1=1)  //*get all jobs not closed but marked completed
		
		
	: (rb2=1)  //*get all jobs closed in the time frame
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]ClosedDate:11>=dDateBegin; *)
		QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]ClosedDate:11<=dDateEnd)
		vTotRec:=Records in selection:C76([Job_Forms:42])
		If (vTotRec>0)
			SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; aJFID; [Jobs:15]CustomerName:5; aCustName; [Jobs:15]Line:3; aLine)  //*dump into an array for user selection
			SORT ARRAY:C229(aJFID; aCustName; aLine)
			ARRAY TEXT:C222(aRpt; Size of array:C274(aJFID))
			For ($i; 1; Size of array:C274(aRpt))
				aRpt{$i}:=""
			End for 
		Else 
			BEEP:C151
			ALERT:C41("There are no Closed Jobs in that date range.")
		End if 
		aJobNo:=""
		vSel:=0
		
	: (rb4=1)  //*get all jobs completed in the time frame
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]Completed:18>=dDateBegin; *)
		QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]Completed:18<=dDateEnd; *)
		QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]ClosedDate:11=!00-00-00!)
		vTotRec:=Records in selection:C76([Job_Forms:42])
		If (vTotRec>0)
			SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; aJFID; [Jobs:15]CustomerName:5; aCustName; [Jobs:15]Line:3; aLine)  //*dump into an array for user selection
			SORT ARRAY:C229(aJFID; aCustName; aLine)
			ARRAY TEXT:C222(aRpt; Size of array:C274(aJFID))
			For ($i; 1; Size of array:C274(aRpt))
				aRpt{$i}:=""
			End for 
		Else 
			BEEP:C151
			ALERT:C41("There are no Completed Jobs in that date range.")
		End if 
		aJobNo:=""
		vSel:=0
		
	: (rb3=1)
		
End case 
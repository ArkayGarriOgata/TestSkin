//%attributes = {"publishedWeb":true}
//(p) rPostingLog
//print a log file of VF -> AMS issue ticket posts
//• 2/2/98 cs created
//• 3/11/98 cs added subtitle on report to show date range report was printed for

C_DATE:C307(dDateBegin; dDateEnd)
C_TEXT:C284(t3)  //subtitle on report

uDialog("DateRange2"; 230; 120)

If (OK=1)
	$StartTime:=TSTimeStamp(dDateBegin; ?00:00:00?)
	$EndTime:=TSTimeStamp(dDateEnd; ?23:59:59?)
	
	QUERY:C277([Job_Forms_Issue_Tickets:90]; [Job_Forms_Issue_Tickets:90]tsTimeStamp:7>=$StartTime; *)
	QUERY:C277([Job_Forms_Issue_Tickets:90];  & ; [Job_Forms_Issue_Tickets:90]tsTimeStamp:7<=$EndTime)
	
	If (Records in selection:C76([Job_Forms_Issue_Tickets:90])>0)
		t3:="For date range: "+String:C10(dDateBegin)+" to "+String:C10(dDateEnd)  //• 3/11/98 cs
		ORDER BY:C49([Job_Forms_Issue_Tickets:90]; [Job_Forms_Issue_Tickets:90]Posted:4; >; [Job_Forms_Issue_Tickets:90]PoItemKey:1; >)
		util_PAGE_SETUP(->[Job_Forms_Issue_Tickets:90]; "PostingLog")
		PRINT SETTINGS:C106
		
		If (OK=1)
			FORM SET OUTPUT:C54([Job_Forms_Issue_Tickets:90]; "PostingLog")
			PRINT SELECTION:C60([Job_Forms_Issue_Tickets:90]; *)
			FORM SET OUTPUT:C54([Job_Forms_Issue_Tickets:90]; "List")
		End if 
	Else 
		ALERT:C41("No Issue Tickets found which were added to AMS "+"(Inserted by VF)"+" during the entered time frame.")
	End if 
End if 
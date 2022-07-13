//%attributes = {"publishedWeb":true}
//(p) rAIssExceptions (A = auto)
//print report listing any proccessing exceptions
//$1 - string - what to do for search & print settings
//• 11/5/97 cs  created
//• 3/9/98 cs modifed so that this report can be printed from report menu
//• 6/26/98 cs added report of new exception status

C_TEXT:C284($1)
C_DATE:C307(dDateBegin)

QUERY:C277([Job_Forms_Issue_Tickets:90]; [Job_Forms_Issue_Tickets:90]Posted:4=2; *)
QUERY:C277([Job_Forms_Issue_Tickets:90];  | ; [Job_Forms_Issue_Tickets:90]Posted:4=3; *)
QUERY:C277([Job_Forms_Issue_Tickets:90];  | ; [Job_Forms_Issue_Tickets:90]Posted:4=4; *)  //• 6/26/98 cs include new exception
QUERY:C277([Job_Forms_Issue_Tickets:90];  | ; [Job_Forms_Issue_Tickets:90]Posted:4=5; *)  //• 7/31/98 cs new exception - no jobform
Case of 
	: (Count parameters:C259=0)  //printing from manual run
		QUERY:C277([Job_Forms_Issue_Tickets:90];  & ; [Job_Forms_Issue_Tickets:90]PostDate:8=4D_Current_date)  //• 3/9/98 cs limit report to current run of batch
	: ($1="S")  //S pecial - the posting of issue tickets was done by hand NOT by BATCH
		QUERY:C277([Job_Forms_Issue_Tickets:90];  & ; [Job_Forms_Issue_Tickets:90]PostDate:8=4D_Current_date)  //• 3/9/98 cs limit report to current run of batch
	Else   //R eprting report
		
		Repeat 
			dDatebegin:=Date:C102(Request:C163("Please enter a  POSTING date to reprint."; "00/00/00"))
		Until (OK=0) | (dDateBegin#!00-00-00!)
		
		If (OK=1)
			QUERY:C277([Job_Forms_Issue_Tickets:90];  & ; [Job_Forms_Issue_Tickets:90]PostDate:8=dDateBegin)  //• 3/9/98 cs limit report to current run of batch
		Else 
			QUERY:C277([Job_Forms_Issue_Tickets:90];  & ; [Job_Forms_Issue_Tickets:90]tsTimeStamp:7=-123456)  //• 3/9/98 cs Force search to fail
		End if 
End case 

If (Records in selection:C76([Job_Forms_Issue_Tickets:90])>0)
	MESSAGE:C88("Printing Exception Report..."+Char:C90(13))
	FORM SET OUTPUT:C54([Job_Forms_Issue_Tickets:90]; "ExceptionRpt")
	ORDER BY:C49([Job_Forms_Issue_Tickets:90]; [Job_Forms_Issue_Tickets:90]Posted:4; >; [Job_Forms_Issue_Tickets:90]PoItemKey:1; >)
	BREAK LEVEL:C302(1)
	ACCUMULATE:C303([Job_Forms_Issue_Tickets:90]Quantity:6)
	util_PAGE_SETUP(->[Job_Forms_Issue_Tickets:90]; "ExceptionRpt")
	
	If (Count parameters:C259=1)
		PRINT SETTINGS:C106
	End if 
	PRINT SELECTION:C60([Job_Forms_Issue_Tickets:90]; *)
	FORM SET OUTPUT:C54([Job_Forms_Issue_Tickets:90]; "List")
	uClearSelection(->[Job_Forms_Issue_Tickets:90])
End if 
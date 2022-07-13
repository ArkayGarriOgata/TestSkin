//%attributes = {"publishedWeb":true}
//(p)mMachTicketRpt
//12/19/94
//• 4/22/97 cs - found mis spelled date var (dEndDate -> dDateEnd)

READ ONLY:C145([Job_Forms_Machine_Tickets:61])
NewWindow(340; 215; 6; 0; "Enter date range")
DIALOG:C40([zz_control:1]; "DateRange2")

If (OK=1)
	PRINT SETTINGS:C106
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5>=dDateBegin; *)
	QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]DateEntered:5<=dDateEnd)
	
	If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)  //fill arrays for printing, broken into smaller peices for readbility
		FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "RptMachTicket")
		util_PAGE_SETUP(->[Job_Forms_Machine_Tickets:61]; "RptMachTicket")
		MESSAGE:C88(Char:C90(13)+"Printing Machine Ticket Report by Cost Center...")
		ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2; >; [Job_Forms_Machine_Tickets:61]JobFormSeq:16; >)
		PRINT SELECTION:C60([Job_Forms_Machine_Tickets:61]; *)
		MESSAGE:C88(Char:C90(13)+"Printing Machine Ticket Report by Job Form...")
		ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobFormSeq:16; >)
		PRINT SELECTION:C60([Job_Forms_Machine_Tickets:61]; *)
	Else 
		ALERT:C41("There were NO Machine Tickets found to Print in the Date Range: "+String:C10(dDateBegin)+" - "+String:C10(dDateEnd))  //• 4/22/97 cs
	End if 
End if 
UNLOAD RECORD:C212([Job_Forms:42])
READ ONLY:C145([Job_Forms:42])
//READ WRITE([CUSTOMER])
If (<>xText1="")
	ALERT:C41(Uppercase:C13("No exceptions or problems to report."))
	
Else 
	FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "RptMTExcept")
	util_PAGE_SETUP(->[Job_Forms_Machine_Tickets:61]; "RptMTExcept")
	FIRST RECORD:C50([Job_Forms_Machine_Tickets:61])
	ONE RECORD SELECT:C189([Job_Forms_Machine_Tickets:61])
	MESSAGE:C88(Char:C90(13)+"Printing Machine Ticket Exceptions Report...")
	PRINT SELECTION:C60([Job_Forms_Machine_Tickets:61]; *)
End if 

FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "List")
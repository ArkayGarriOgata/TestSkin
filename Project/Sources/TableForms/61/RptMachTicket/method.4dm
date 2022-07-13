//(LP) RptMachTicket:
//12/19/94
Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		If ([Job_Forms:42]JobFormID:5#[Job_Forms_Machine_Tickets:61]JobForm:1)
			QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Job_Forms_Machine_Tickets:61]JobForm:1)
		End if 
		If ([Jobs:15]JobNo:1#[Job_Forms:42]JobNo:2)
			QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=[Job_Forms:42]JobNo:2)
		End if 
End case 
//EOP
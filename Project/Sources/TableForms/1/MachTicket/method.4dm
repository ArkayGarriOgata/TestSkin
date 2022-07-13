//(LP) [CONTROL]'MachTicket
//12/19/94
Case of 
	: (Form event code:C388=On Load:K2:1)
		gClearMT
		rPrintMT:=0
		rPrintExp:=0
		OBJECT SET ENABLED:C1123(bOK; False:C215)  // Added by: Mark Zinke (11/1/13) 
		OBJECT SET ENABLED:C1123(bOKStay; False:C215)  // Added by: Mark Zinke (11/1/13) 
		OBJECT SET ENABLED:C1123(bDelete; False:C215)  // Added by: Mark Zinke (11/1/13) 
		
		If (iQty>0)
			OBJECT SET ENABLED:C1123(bCancel; False:C215)
		End if 
		
		ARRAY TEXT:C222(atDowntime; 0)
		LIST TO ARRAY:C288("Downtime"; atDowntime)
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
		
End case 
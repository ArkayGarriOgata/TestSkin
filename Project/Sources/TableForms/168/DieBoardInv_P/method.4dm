C_TEXT:C284(ttPrinted)
C_LONGINT:C283(xlRemain; xlImpressions)
Case of 
	: (Form event code:C388=On Printing Detail:K2:18)
		xlRemain:=DieBoardGetImpressions(->xlImpressions)
		
	: (Form event code:C388=On Printing Footer:K2:20)
		ttPrinted:="Printed "+String:C10(4D_Current_date; System date short:K1:1)+" @ "+String:C10(4d_Current_time; System time short:K7:9)
End case 
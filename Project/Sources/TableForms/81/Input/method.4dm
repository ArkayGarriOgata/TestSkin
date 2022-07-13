Case of 
	: (Form event code:C388=On Validate:K2:3)
		READ WRITE:C146([zz_control:1])
		ALL RECORDS:C47([zz_control:1])
		[zz_control:1]ExpenseDate:44:=4D_Current_date-1
		SAVE RECORD:C53([zz_control:1])
		REDUCE SELECTION:C351([zz_control:1]; 0)
End case 
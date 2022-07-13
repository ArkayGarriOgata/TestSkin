Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Is new record:C668([Cost_Ctr_Down_Times:139]))
			[Cost_Ctr_Down_Times:139]dt_id:1:=app_GetPrimaryKey
		End if 
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
		
	: (Form event code:C388=On Validate:K2:3)
		READ WRITE:C146([zz_control:1])
		ALL RECORDS:C47([zz_control:1])
		[zz_control:1]DownTimeDate:56:=4D_Current_date-1
		SAVE RECORD:C53([zz_control:1])
		REDUCE SELECTION:C351([zz_control:1]; 0)
		
		uConfirm("Updated list will be available on next login."; "OK"; "Help")
End case 
//FM: Input() -> 
//@author mlb - 8/3/01  15:52

Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Is new record:C668([QA_Corrective_ActionsReason:106]))
			[QA_Corrective_ActionsReason:106]id:1:=String:C10(app_AutoIncrement(->[QA_Corrective_ActionsReason:106]); "00000")
		End if 
End case 
Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Is new record:C668([QA_Section:109]))
			[QA_Section:109]ProcedureId:1:=[QA_Procedures:108]id:1
		End if 
		
End case 
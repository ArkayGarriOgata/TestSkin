Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Is new record:C668([QA_Tests:134]))
			[QA_Tests:134]TestID:1:=QA_TestGetNextID
		End if 
		
	: (Form event code:C388=On Close Box:K2:21)
		SAVE RECORD:C53([QA_Tests:134])
End case 

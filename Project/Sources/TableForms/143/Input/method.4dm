//[CAR_ToDos]Input Form Method

C_TEXT:C284(tHoldNoteField)
C_LONGINT:C283($LFormEvent)

$LFormEvent:=Form event code:C388

Case of 
	: ($LFormEvent=On Load:K2:1)
		
		tHoldNoteField:=[QA_Corrective_Actions_Notes:143]Note:5
		
	: ($LFormEvent=On Close Box:K2:21)
		CANCEL:C270
End case 

//••••••••••eop••••••••••
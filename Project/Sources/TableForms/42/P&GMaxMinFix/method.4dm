// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 04/18/13, 12:27:29
// ----------------------------------------------------
// Method: [Job_Forms].P&GMaxMinFix
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		Est_PandGBlob("Read")
		PGComments:=[Job_Forms:42]PandGProbsComments:85
		LISTBOX SORT COLUMNS:C916(abList; 1; >)
		
		If ([Job_Forms:42]PandGProbsCkByMgr:84)
			SetObjectProperties(""; ->PGComments; True:C214; ""; False:C215)
			SetObjectProperties(""; ->bFix; False:C215)
			SetObjectProperties(""; ->bOverride; True:C214; "OK")
		Else 
			SetObjectProperties(""; ->PGComments; True:C214; ""; True:C214)
			SetObjectProperties(""; ->bFix; True:C214)
			SetObjectProperties(""; ->bOverride; True:C214; "Send Email & Override")
		End if 
		
End case 
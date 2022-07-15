//%attributes = {}
/*
Method:  Skin_Demo_AcceptRound
Description:  This method loads the accept button.

Notes: This is just used as a way to dynamically load a button
*/

If (True:C214)  //Initialize
	
	$nFormEvent:=Form event code:C388
	
End if   //Done initialize

Case of   //Form event
		
	: ($nFormEvent=On Load:K2:1)
		
		Skin_SetIcon
		
End case   //Done form event

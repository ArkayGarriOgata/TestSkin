//%attributes = {}
//Method:  Core_LsBx_Event
//Description:  This method handles the form events for
//  the Core_LsBx_ class

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nFormEvent)
	
	$nFormEvent:=Form event code:C388
	
End if   //Done initialize

Case of   //Form event
		
	: ($nFormEvent=On Load:K2:1)
		
		Core_LsBx_OnLoad
		
	: ($nFormEvent=On Clicked:K2:4)
		
		Core_LsBx_OnClicked
		
	: ($nFormEvent=On Double Clicked:K2:5)
		
		Core_LsBx_OnDoubleClicked
		
	: ($nFormEvent=On Header Click:K2:40)
		
		//Core_LsBx_OnHeaderClick
		
	: ($nFormEvent=On Before Keystroke:K2:6)
		
		//Core_LsBx_OnBeforeKeystroke
		
	: ($nFormEvent=On After Keystroke:K2:26)
		
		//Core_LsBx_OnAfterKeystroke
		
End case   //Done form event

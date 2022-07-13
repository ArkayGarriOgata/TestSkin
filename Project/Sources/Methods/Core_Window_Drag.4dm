//%attributes = {}
//Method:  Core_Window_Drag
//Description:  This method allows a moveable floating window to be dragged
//.  Uses set cursor so must be called in the On Mouse Move

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nLeft; $nRight; $nTop; $nBottom; $nMaximumHeight; $nMaximumWidth)
	
	C_LONGINT:C283($nFormEvent)
	
	$nFormEvent:=Form event code:C388
	
End if   //Done initialize

Case of   //Form event
		
	: ($nFormEvent=On Clicked:K2:4)
		
		SET CURSOR:C469(9014)  //Close hand
		
		DRAG WINDOW:C452
		
	: ($nFormEvent=On Mouse Enter:K2:33)
		
		SET CURSOR:C469(9013)  //Open hand
		
	: ($nFormEvent=On Mouse Leave:K2:34)
		
		SET CURSOR:C469  //Reset back to arrow
		
End case   //Done form event


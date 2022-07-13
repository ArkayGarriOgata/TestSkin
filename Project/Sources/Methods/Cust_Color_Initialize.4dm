//%attributes = {}
//Method:  Cust_Color_Initialize(tPhase)
//Description:  This method initializes the Cust_Color form

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	
	C_POINTER:C301($pRadioButton)
	
	$tPhase:=$1
	
End if   //Done Initialize

Case of   //Phase
		
	: ($tPhase=CorektPhaseInitialize)
		
		Core_RadioButton("TextBlack")
		Core_RadioButton("BackWhite")
		
		Case of   //Title
				
			: (Not:C34(OB Is defined:C1231(Form:C1466; "tTitle")))
				
			: (Form:C1466.tTitle=CorektBlank)
				
			Else 
				
				OBJECT SET TITLE:C194(*; "ExampleOfColor"; Form:C1466.tTitle)
				
		End case   //Done title
		
End case   //Done phase
//%attributes = {}
//Method:  Cust_OM_RadioButton(tRadioButton)
//Description:  This method handles the button

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tRadioButton)
	
	$tRadioButton:=$1
	
End if   //Done Initialize

Case of   //Button
		
	: ((Position:C15("Back"; $tRadioButton)=1) | (Position:C15("Text"; $tRadioButton)=1))  //Cust_Color form
		
		Cust_Color_SetExample
		
End case   //Done button

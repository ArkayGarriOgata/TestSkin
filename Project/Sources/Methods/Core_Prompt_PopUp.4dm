//%attributes = {}
//Method:  Core_Prompt_PopUp
//Description:  This method will control the popup

If (True:C214)  //Initialize
	
	ARRAY TEXT:C222($atHint; 0)
	
End if   //Done initialize

Form:C1466.nPopUpSelected:=Pop up menu:C542(Form:C1466.tPopUp)

Case of   //Hint
		
	: (Form:C1466.nPopUpSelected<1)
	: (Not:C34(OB Is defined:C1231(Form:C1466; "tHint")))
	: (Not:C34(Length:C16(Form:C1466.tHint)>2))
		
	Else   //Use hint
		
		Core_Text_ParseToArray(Form:C1466.tHint; ->$atHint; CorektSemiColon)
		
		Core_tPrompt_Hint:=$atHint{Form:C1466.nPopUpSelected}
		
End case   //Done hint

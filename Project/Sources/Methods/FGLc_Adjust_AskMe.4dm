//%attributes = {}
//Method:  FGLC_Adjust_AskMe
//Description:  This method will bring up the ask me dialog

If (True:C214)  //Initialize
	
	vAskMePID:=0
	<>AskMeFG:=FGLc_tAdjust_ProductCode
	<>AskMeCust:=CorektBlank
	
End if   //Done Initialize

displayAskMe("New")
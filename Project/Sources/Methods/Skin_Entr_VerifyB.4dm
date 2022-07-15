//%attributes = {}
//Method: Skin_Entr_VerifyB()
//Description: This method will return True or False for whether the button should be active


If (True:C214)  // begin initialize
	
	C_BOOLEAN:C305($0; $bVerify)
	$bVerify:=False:C215
	
End if   // done initialize

Case of 
	: (Form:C1466.tSource=CorektBlank)
	Else 
		$0:=True:C214
End case 
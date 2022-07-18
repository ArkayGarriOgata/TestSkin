//%attributes = {}
//Method: Skin_Entr_VerifyB()=>bVerify
//Description: This method will return True or False for whether the button should be active

If (True:C214)  // Initalize
	
	C_BOOLEAN:C305($0; $bVerify)
	$bVerify:=False:C215
	
End if   // Done initialize

Case of   //Verify
		
	: (Form:C1466.tSource=CorektBlank)
		
	Else 
		
		$bVerify:=True:C214
		
End case   //Done verify

$0:=$bVerify
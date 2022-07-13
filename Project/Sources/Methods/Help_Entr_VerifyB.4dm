//%attributes = {}
//Method:  Help_Entr_VerifyB=>bVerified
//Description:  This method verifies that a record can be saved

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($0; $bVerify)
	
	$bVerify:=False:C215
	
End if   //Done initialize

Case of   //Verify
	: (Form:C1466.tCategory=CorektBlank)
	: (Form:C1466.tTitle=CorektBlank)
	: (Form:C1466.tPathName=CorektBlank)
	: (Form:C1466.tKeyword=CorektBlank)
	Else 
		$bVerify:=True:C214; 
End case   //Done verify

$0:=$bVerify
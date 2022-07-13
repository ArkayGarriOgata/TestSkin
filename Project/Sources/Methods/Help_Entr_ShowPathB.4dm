//%attributes = {}
//Method:  Help_Entr_ShowPathB=>bVerified
//Description:  This method verifies that a pathname is filled in

If (True:C214)  // Initialize
	
	C_BOOLEAN:C305($0; $bVerified)
	
End if   //Done initialize

$bVerified:=(Form:C1466.tPathName#CorektBlank)

$0:=$bVerified
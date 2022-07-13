//%attributes = {}
//Method:  Core_Backup_VerifyError
//Description:  This method will handle errors when testing a document
//  It keeps errors from appearing on the server.

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nError)
	
	$nError:=Error  //trap error for now
	
End if   //Done Initialize

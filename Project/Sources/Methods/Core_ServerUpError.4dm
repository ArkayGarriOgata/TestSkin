//%attributes = {}
//Method:  Core_ServerUpError
//Description:  This method will handle errors when logging into a server
//  If it doesn't login then an error would appear on the server.
//  So this just makes sure that error is not appear.

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nError)
	
	$nError:=Error  //trap error for now
	
End if   //Done Initialize

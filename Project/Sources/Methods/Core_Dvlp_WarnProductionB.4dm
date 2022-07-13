//%attributes = {}
//Method:  Core_Dvlp_WarnProductionB=>bAbort
//Description:  The following method will check if in Development and warn about code that could
//. run as if in production

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($0; $bAbort)
	C_OBJECT:C1216($oConfirm)
	
	$bAbort:=False:C215
	
	$oConfirm:=New object:C1471()
	
	$oConfirm.tMessage:="You are developing and about to run code that will modify production. Do you want to Abort?"
	
	$oConfirm.tDefault:="Abort"
	$oConfirm.tCancel:="Run Production"
	
End if   //Done Initialize

Case of   //Abort
		
	: (Application type:C494=4D Server:K5:6)  //Assume production
	: (Core_Dialog_ConfirmN($oConfirm)#CoreknDefault)  //They are ok 
		
	Else   //Abort
		
		$bAbort:=True:C214
		
End case   //Done abort

$0:=$bAbort

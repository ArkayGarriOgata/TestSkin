//%attributes = {"publishedWeb":true}
//Procedure : execute err
//Called From : on err call, apply to selection, 1myexecute

If (Error#1006)  //debugger interupt
	ALERT:C41("An Error Has Occured While Executing the Entered Statement!"+<>sCr+"The Error was : "+String:C10(Error)+<>sCr+vCommand)
	CANCEL:C270
	ON ERR CALL:C155("")
	ABORT:C156
End if 
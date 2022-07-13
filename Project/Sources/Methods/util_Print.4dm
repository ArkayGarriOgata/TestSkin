//%attributes = {"publishedWeb":true}
//PM: util_Print() -> 
//@author mlb - 5/21/02  11:31

If (printMenuSupported)
	SET AUTOMATIC RELATIONS:C310(True:C214; True:C214)
	USE SET:C118("◊LastSelection"+String:C10(fileNum))
	QR REPORT:C197(filePtr->; "x")
	
Else 
	BEEP:C151
End if 
//•031297  mBohince  reduce selections
//• 11/7/97 cs insure input layout selection
If (Records in set:C195("Job_Forms_Items")>0)
	sAskMeSaveState("save")
	
	util_openTheSelectRecordInList(->[Job_Forms_Items:44]JobForm:1; ->[Job_Forms:42]JobFormID:5)
	
	sAskMeSaveState("recall")
	
Else 
	BEEP:C151
End if 

//
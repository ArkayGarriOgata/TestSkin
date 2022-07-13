//(s) bOk [control]directbillink
Case of 
	: (sJobform="")
		ALERT:C41("You must enter a JobForm.")
		GOTO OBJECT:C206(sJobform)
	: (sRmCode="")
		ALERT:C41("You must enter a Material Code.")
		GOTO OBJECT:C206(sRmCode)
	: (rReal1=0)
		ALERT:C41("You must enter a Quantity to Issue.")
		GOTO OBJECT:C206(rReal1)
	Else 
		ACCEPT:C269
End case 
//
//(s) bOK
Case of 
	: (r2=0)
		ALERT:C41("You need to enter a Classification")
		GOTO OBJECT:C206(r2)
		REJECT:C38
	: (r3=0)
		ALERT:C41("You need to enter a Quantity")
		GOTO OBJECT:C206(r3)
		REJECT:C38
	: (r5=0)
		ALERT:C41("You need to enter a Price")
		GOTO OBJECT:C206(r5)
		REJECT:C38
	: (sDesc="")
		ALERT:C41("You need to enter a Description")
		GOTO OBJECT:C206(sDesc)
End case 
//eos.
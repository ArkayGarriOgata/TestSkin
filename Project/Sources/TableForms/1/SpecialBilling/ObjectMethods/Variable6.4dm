//(s) bOK
Case of 
	: (sPOLocation="") | (sPOLocation="0")
		ALERT:C41("You Need to Enter a Cost")
		sPOLocation:="0"
		GOTO OBJECT:C206(sPOLocation)
	: (sChargeCode="") | (sChargeCode="0")
		ALERT:C41("You Need to Enter a Quantity")
		GOTO OBJECT:C206(sChargeCode)
	: (sDesc="")
		ALERT:C41("You Need to Enter a Description")
		GOTO OBJECT:C206(sDesc)
	Else 
		ACCEPT:C269
End case 
//eos.
//(s) baccept [control]selectcust
Case of 
	: (dDateEnd<dDateBegin)
		ALERT:C41("Ending date BEFORE begining Date.")
		Self:C308->:=4D_Current_date
		GOTO OBJECT:C206(dDateEnd)
		REJECT:C38
	: (sCustName="")
		ALERT:C41("You Need to Select a Valid Csutomer.")
		REJECT:C38
		GOTO OBJECT:C206(sCust)
End case 
//eop

//(S) sBinPO: Script to Search for PO No.  If it does not exist then create it.
Case of 
	: (sPONumber="")
		BEEP:C151
		ALERT:C41("A Budget Item must be selected.")
		sPONo:=""
	: (sBinNo="")
		BEEP:C151
		ALERT:C41("A Location must be selected.")
		sPONo:=""
	Else 
		RM_ValidBinPO
End case 
//EOS
//(S) sBinNo: Script to Search for Bin No.  If it does not exist then create it.
If (sPONumber="")
	ALERT:C41("A Budget Item must be selected.")
	sBinNo:=""
Else 
	RM_validBinLocation
End if 
//EOS
Case of   //4/25/95
	: (Form event code:C388=On Load:K2:1)
		C_DATE:C307(dDateBegin; dDateEnd)
		C_TEXT:C284(sCust)
		C_TEXT:C284(sCustName)
		C_LONGINT:C283(rbOrig; rbVendor; rbDivision)  //•100997  mBohince  UPR 
		dDateBegin:=4D_Current_date-30
		dDateEnd:=4D_Current_date
		sCust:=""
		sCustName:=""
		rbOrig:=1  //both haup & roan
		rbVendor:=0  //just haup
		rbDivision:=0  //just raon
End case 
//
Case of 
	: (Form event code:C388=On Load:K2:1)
		C_BOOLEAN:C305(fNew)
		fNew:=False:C215
		xTitle:="Use Popup->"
		ARRAY TEXT:C222(aCommCode; 0)
		ARRAY TEXT:C222(aCommCode2; 0)
		LIST TO ARRAY:C288("CommCodes"; aCommCode)
		COPY ARRAY:C226(aCommCode; aCommCode2)
End case 
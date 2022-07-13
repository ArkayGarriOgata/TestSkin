Case of 
	: (Form event code:C388=On Double Clicked:K2:5)
		OBJECT SET ENTERABLE:C238(*; "caliper"; True:C214)
		GOTO OBJECT:C206(*; "caliper")
		
	: (Form event code:C388=On Data Change:K2:15)
		Form:C1466.qty:=Trunc:C95(Form:C1466.height/Form:C1466.caliper; -1)
		Form:C1466.numberLoads:=Job_ConvertSheetsToLoads(Form:C1466.grossSheets; Form:C1466.caliper; Form:C1466.height)
End case 

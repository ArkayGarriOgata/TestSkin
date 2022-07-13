Case of 
	: (Form event code:C388=On Load:K2:1)
		ARRAY TEXT:C222(aText; 0)
		sCriterion1:=""
		dDate:=!00-00-00!
		rb1:=1
		SetObjectProperties(""; ->dDate; True:C214; ""; False:C215)
		CREATE EMPTY SET:C140([Purchase_Orders:11]; "Found")
End case 
//(LOP) [ITEM];"ItemBudInclList"
Case of 
	: (Form event code:C388=On Load:K2:1)
		If ([Job_Forms:42]JobFormID:5="")
			ALERT:C41("Cannot add Items until Job No. is entered!!!")
			DELETE RECORD:C58([Job_Forms_Items:44])
		End if 
End case 
//EOLP

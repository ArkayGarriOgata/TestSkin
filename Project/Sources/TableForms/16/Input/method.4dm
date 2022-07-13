Case of 
	: (Form event code:C388=On Load:K2:1)
		beforeCust
		
	: (Form event code:C388=On Clicked:K2:4)
		Case of 
			: (FORM Get current page:C276=3)
				$numSubRecs:=util_getTheSelectedRecordInList(->[Customers_Addresses:31]; ->bOpenAddress; "Address"; "Addresses")
				If ($numSubRecs>0) & (iMode<=2)
					OBJECT SET ENABLED:C1123(bdelRel1; True:C214)
				End if 
			: (FORM Get current page:C276=4)
				$numSubRecs:=util_getTheSelectedRecordInList(->[Customers_Contacts:52]; ->bOpenContact; "Contact"; "Contacts")
				If ($numSubRecs>0) & (iMode<=2)
					OBJECT SET ENABLED:C1123(bdelRel2; True:C214)
				End if 
		End case 
		
	: (Form event code:C388=On Validate:K2:3)
		If (iMode=1)
			User_GiveAccess(<>zResp; "Customers"; [Customers:16]ID:1; "RWD")
		End if 
		[Customers:16]ModDate:22:=4D_Current_date
		[Customers:16]ModWho:23:=<>zResp
		
	: (Form event code:C388=On Close Box:K2:21)
		bDone:=1
		CANCEL:C270
End case 


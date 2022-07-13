
Case of 
	: (Form event code:C388=On Load:K2:1)
		sCConAction:=fGetMode(iMode)
		Case of 
			: (Is new record:C668([Contacts:51]))
				sCConAction:="NEW"
				[Contacts:51]ContactID:1:=app_set_id_as_string(Table:C252(->[Contacts:51]))
				[Contacts:51]ModWho1st:16:=<>zResp
				[Contacts:51]zCount:18:=1
				
			: (iMode=2)
				OBJECT SET ENABLED:C1123(bDelete; True:C214)
				OBJECT SET ENABLED:C1123(bLinkRel; True:C214)
				OBJECT SET ENABLED:C1123(bLinkRel2; True:C214)
				OBJECT SET ENABLED:C1123(bAcceptRec; True:C214)
				
			Else 
				OBJECT SET ENABLED:C1123(bDelete; False:C215)
				OBJECT SET ENABLED:C1123(bLinkRel; False:C215)
				OBJECT SET ENABLED:C1123(bLinkRel2; False:C215)
				OBJECT SET ENABLED:C1123(bAcceptRec; False:C215)
		End case 
		
		
	: (Form event code:C388=On Close Box:K2:21)
		bDone:=1
		CANCEL:C270
		
	: (Form event code:C388=On Validate:K2:3)
		[Contacts:51]ModDate:19:=4D_Current_date
		[Contacts:51]ModWho:20:=<>zResp
End case 
//

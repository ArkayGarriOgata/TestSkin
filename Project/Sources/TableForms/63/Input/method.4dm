//(LP) [Fiscal_Calendar]'Input
Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Records in selection:C76([x_fiscal_calendars:63])=-3)
			sAction:="NEW"
			OBJECT SET ENABLED:C1123(bDummy; False:C215)
		Else 
			sAction:="MODIFY"
			OBJECT SET ENABLED:C1123(bDummy; True:C214)
		End if 
		
	: (Form event code:C388=On Validate:K2:3)
		uUpdateTrail(->[x_fiscal_calendars:63]ModDate:5; ->[x_fiscal_calendars:63]ModWho:6; ->[x_fiscal_calendars:63]zCount:7)
End case 
//EOP
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 02/07/13, 12:02:29
// ----------------------------------------------------
// Method: [zz_control].SaleEvent
// ----------------------------------------------------

If (Form event code:C388=On Load:K2:1)
	If (User in group:C338(Current user:C182; "SalesManager")) | (User in group:C338(Current user:C182; "RoleSuperUser"))
		OBJECT SET ENABLED:C1123(bChgRep; True:C214)
		OBJECT SET ENABLED:C1123(ibNew; True:C214)
	Else 
		OBJECT SET ENABLED:C1123(bChgRep; False:C215)
		OBJECT SET ENABLED:C1123(ibNew; False:C215)
	End if 
	
	If (<>bButtons)  // Added by: Mark Zinke (2/6/13)
		FORM GOTO PAGE:C247(2)
		GET WINDOW RECT:C443($xlLeft; $xlTop; $xlRight; $xlBottom)
		SET WINDOW RECT:C444($xlLeft; $xlTop; $xlRight-70; $xlBottom-90)
	End if 
End if 
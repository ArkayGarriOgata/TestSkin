// ----------------------------------------------------
// Form Method: [Job_Forms_Master_Schedule].ListMany
// SetObjectProperties, Mark Zinke (5/17/13)
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		b1:=0
		b2:=0
		b3:=0
		b4:=1
		cb1:=0
		cb2:=1
		cb3:=0
		i1:=1
		i2:=1
		lastTab:=1
		SELECT LIST ITEMS BY POSITION:C381(iJMLTabs; lastTab)
		FORM GOTO PAGE:C247(1)
		If (User in group:C338(Current user:C182; "RoleOperations"))
			OBJECT SET ENABLED:C1123(bPriority; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bPriority; False:C215)
		End if 
		
	: (Form event code:C388=On Display Detail:K2:22)
		JML_setColors
		
		SET QUERY LIMIT:C395(1)
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Job_Forms_Master_Schedule:67]JobForm:4)
		SET QUERY LIMIT:C395(0)
		SetObjectProperties(""; ->tHold; True:C214; ""; True:C214; Red:K11:4; White:K11:1)
		Case of 
			: (Position:C15("hold"; [Job_Forms:42]Status:6)>0)
				tHold:="HOLD"
				
			: (Position:C15("kill"; [Job_Forms:42]Status:6)>0)
				tHold:="KILL"
				
			: (Position:C15("WIP"; [Job_Forms:42]Status:6)>0)
				tHold:="WIP"
				SetObjectProperties(""; ->tHold; True:C214; ""; True:C214; Green:K11:9; White:K11:1)
			Else 
				tHold:=""
				SetObjectProperties(""; ->tHold; False:C215)
		End case 
		
	: (Form event code:C388=On Unload:K2:2)
		<>jobform:=""
End case 
// ----------------------------------------------------
// Form Method: Rama_Palette
// SetObjectProperties, Mark Zinke (5/16/13)
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		Rama_Find_CPNs("init")  //always reload when palette is opened
		<>Rama_Palette_Entry:=True:C214
		zwStatusMsg("RAMA"; "palette open "+String:C10(<>Rama_Palette_Entry))
		If (User in group:C338(Current user:C182; "RoleRestrictedAccess"))
			SetObjectProperties(""; ->bImport; False:C215)
			OBJECT SET ENABLED:C1123(bImport; False:C215)
			
		Else 
			SetObjectProperties(""; ->bImport; True:C214)
			OBJECT SET ENABLED:C1123(bImport; True:C214)
		End if 
		
		OBJECT SET ENABLED:C1123(rb2; False:C215)  //glue schd btn
		
		
	: (Form event code:C388=On Close Box:K2:21)
		If (User in group:C338(Current user:C182; "RoleRestrictedAccess"))
			uConfirm("Are you sure you want to quit?"; "Quit"; "Cancel")
			If (ok=1)
				Rama_Find_CPNs("kill")
				<>Rama_Palette_Entry:=False:C215
				CANCEL:C270
				QUIT 4D:C291
			End if 
		Else 
			<>Rama_Palette_Entry:=False:C215
			CANCEL:C270
		End if 
		
End case 
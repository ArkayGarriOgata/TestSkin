//[Process_Specs_Materials];"Input"

Case of   //(LP) [material_pspec]'Input
	: (Form event code:C388=On Load:K2:1)
		
		If (Is new record:C668([Process_Specs_Materials:56]))
			CANCEL:C270
			
		Else 
			If (imode>2)
				OBJECT SET ENABLED:C1123(bValidate; False:C215)
				OBJECT SET ENABLED:C1123(bGetRM; False:C215)
				OBJECT SET ENABLED:C1123(bChange; False:C215)
				OBJECT SET ENABLED:C1123(bDelete; False:C215)
			Else 
				If (testRestrictions)
					OBJECT SET ENABLED:C1123(bChange; False:C215)
					OBJECT SET ENABLED:C1123(bGetRM; False:C215)
					OBJECT SET ENABLED:C1123(bChange; False:C215)
					OBJECT SET ENABLED:C1123(bDelete; False:C215)
				End if 
			End if 
			
			
			sSetPspecMatl
		End if 
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
		
	: (Form event code:C388=On Unload:K2:2)
		
	: (Form event code:C388=On Validate:K2:3)
		uUpdateTrail(->[Process_Specs_Materials:56]ModDate:11; ->[Process_Specs_Materials:56]ModWho:10; ->[Process_Specs_Materials:56]zCount:12)
End case 
//
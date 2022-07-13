
Case of   //(LP) [material_Est]'Input
	: (Form event code:C388=On Load:K2:1)
		sSetMatlEstFlex
		If (Is new record:C668([Estimates_Materials:29]))
			[Estimates_Materials:29]DiffFormID:1:=[Estimates_DifferentialsForms:47]DiffFormId:3
		Else 
			If (imode>2)
				OBJECT SET ENABLED:C1123(bValidate; False:C215)
			End if 
		End if 
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
		
	: (Form event code:C388=On Validate:K2:3)
		Estimate_ReCalcNeeded
		uUpdateTrail(->[Estimates_Materials:29]ModDate:22; ->[Estimates_Materials:29]ModWho:21; ->[Estimates_Materials:29]zCount:23)
End case 
//
<>iLayout:=2501  //(LP) [RM_BINS]'Input
Case of 
	: (Form event code:C388=On Load:K2:1)
		beforeRMBN
		
	: (Form event code:C388=On Validate:K2:3)
		uUpdateTrail(->[Raw_Materials_Locations:25]ModDate:21; ->[Raw_Materials_Locations:25]ModWho:22; ->[Raw_Materials_Locations:25]zCount:20)
End case 
//


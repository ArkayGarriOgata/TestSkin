<>iLayout:=2201  //(LP) [RM_GROUP]Input
Case of 
	: (Form event code:C388=On Load:K2:1)
		beforeRMGP
		
	: (Form event code:C388=On Close Box:K2:21)
		bDone:=1
		CANCEL:C270
		
	: (Form event code:C388=On Unload:K2:2)
		fRMGPMaint:=False:C215
		fCancel:=True:C214
		wWindowTitle("pop")
		
	: (Form event code:C388=On Validate:K2:3)
		uUpdateTrail(->[Raw_Materials_Groups:22]ModDate:6; ->[Raw_Materials_Groups:22]ModWho:7; ->[Raw_Materials_Groups:22]zCount:5)
End case 
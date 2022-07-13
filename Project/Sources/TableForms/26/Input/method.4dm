Case of 
	: (Form event code:C388=On Load:K2:1)
		beforeFG
		
	: (Form event code:C388=On Validate:K2:3)
		//SAVE RECORD([Job_Forms_Items])
		//REDUCE SELECTION([Job_Forms_Items];0)
		afterFG
		uUpdateTrail(->[Finished_Goods:26]ModDate:24; ->[Finished_Goods:26]ModWho:25; ->[Finished_Goods:26]zCount:30)
		
	: (Form event code:C388=On Close Box:K2:21)
		afterFG
		uUpdateTrail(->[Finished_Goods:26]ModDate:24; ->[Finished_Goods:26]ModWho:25; ->[Finished_Goods:26]zCount:30)
		ACCEPT:C269
		
	: (Form event code:C388=On Outside Call:K2:11)
		If (<>fQuit4D)
			afterFG
			uUpdateTrail(->[Finished_Goods:26]ModDate:24; ->[Finished_Goods:26]ModWho:25; ->[Finished_Goods:26]zCount:30)
			ACCEPT:C269
		End if 
End case 
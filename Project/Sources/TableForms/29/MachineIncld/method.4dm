Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Estimates_Materials:29]Raw_Matl_Code:4)
		
	: (Form event code:C388=On Data Change:K2:15)
		Estimate_ReCalcNeeded
End case 
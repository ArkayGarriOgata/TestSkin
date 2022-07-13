Case of 
	: (Form event code:C388=On Display Detail:K2:22) & (Not:C34(Form event code:C388=On Load:K2:1))  //user double clicked
		
		Case of 
			: ([WMS_Label_Tracking:75]WhichLabel:11=1)
				FORM SET INPUT:C55([WMS_Label_Tracking:75]; "Standard")
			: ([WMS_Label_Tracking:75]WhichLabel:11=2)
				FORM SET INPUT:C55([WMS_Label_Tracking:75]; "Bradley")
			: ([WMS_Label_Tracking:75]WhichLabel:11=3)
				FORM SET INPUT:C55([WMS_Label_Tracking:75]; "Coty")
			: ([WMS_Label_Tracking:75]WhichLabel:11=4)
				FORM SET INPUT:C55([WMS_Label_Tracking:75]; "Faberge")
		End case 
End case 
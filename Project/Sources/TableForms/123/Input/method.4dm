
Case of 
	: (Form event code:C388=On Load:K2:1)
		READ WRITE:C146([WMS_Compositions:124])
		QUERY:C277([WMS_Compositions:124]; [WMS_Compositions:124]Container:1=[WMS_ItemMasters:123]PalletID:11)
		ORDER BY:C49([WMS_Compositions:124]; [WMS_Compositions:124]Content:2; >)
End case 

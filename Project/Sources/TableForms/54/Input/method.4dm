Case of 
	: (Form event code:C388=On Load:K2:1)
		READ ONLY:C145([Purchase_Orders_Items:12])
		READ ONLY:C145([Raw_Materials:21])
		RELATE MANY:C262([Raw_Material_Commodities:54]CommodityID:1)
		ORDER BY:C49([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3; >)
End case 
//
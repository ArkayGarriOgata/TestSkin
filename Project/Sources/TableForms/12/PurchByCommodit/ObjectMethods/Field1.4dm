If ([Raw_Materials_Groups:22]Commodity_Code:1#[Purchase_Orders_Items:12]CommodityCode:16)
	QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Code:1=[Purchase_Orders_Items:12]CommodityCode:16; *)
	QUERY:C277([Raw_Materials_Groups:22];  & ; [Raw_Materials_Groups:22]SubGroup:10="")
End if 
//
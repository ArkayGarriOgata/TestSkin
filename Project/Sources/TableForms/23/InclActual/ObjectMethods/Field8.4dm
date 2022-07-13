If ([Raw_Materials_Transactions:23]viaLocation:11="ShortForm")
	READ ONLY:C145([Raw_Materials:21])
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Raw_Materials_Transactions:23]Raw_Matl_Code:1)
	If (Records in selection:C76([Raw_Materials:21])=1)
		[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=[Raw_Materials:21]Raw_Matl_Code:1
		[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
		[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
		[Raw_Materials_Transactions:23]Commodity_Key:22:=[Raw_Materials:21]Commodity_Key:2
		[Raw_Materials_Transactions:23]CommodityCode:24:=[Raw_Materials:21]CommodityCode:26  //11/15/94
	Else 
		uConfirm("Invalid Raw Material Code."; "OK"; "Help")
		[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=Old:C35([Raw_Materials_Transactions:23]Raw_Matl_Code:1)
	End if 
	
Else 
	uConfirm("You may only change Raw Material Codes on transactions enter with the Add button "+"on this page."; "OK"; "Help")
	[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=Old:C35([Raw_Materials_Transactions:23]Raw_Matl_Code:1)
End if 
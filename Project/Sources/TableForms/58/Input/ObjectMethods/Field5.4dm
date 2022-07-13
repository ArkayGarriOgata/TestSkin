//OM: Raw_Matl_Code() -> 
//@author mlb - 6/26/01  11:52

If ([Raw_Materials:21]Raw_Matl_Code:1#[Raw_Materials_Allocations:58]Raw_Matl_Code:1)
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Raw_Materials_Allocations:58]Raw_Matl_Code:1)
End if 

If (Records in selection:C76([Raw_Materials:21])=0)
	BEEP:C151
	ALERT:C41([Raw_Materials_Allocations:58]Raw_Matl_Code:1+" is not a valid Raw Matl Code")
	[Raw_Materials_Allocations:58]Raw_Matl_Code:1:=""
	[Raw_Materials_Allocations:58]commdityKey:13:=""
Else 
	[Raw_Materials_Allocations:58]commdityKey:13:=[Raw_Materials:21]Commodity_Key:2
	
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=[Raw_Materials_Allocations:58]Raw_Matl_Code:1)
	
	QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]Raw_Matl_Code:15=[Raw_Materials_Allocations:58]Raw_Matl_Code:1; *)
	QUERY:C277([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]Qty_Open:27>0)
	
End if 
If ([Raw_Materials:21]Raw_Matl_Code:1#[Raw_Materials_Transactions:23]Raw_Matl_Code:1)
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Raw_Materials_Transactions:23]Raw_Matl_Code:1)
End if 

If ([Raw_Materials_Transactions:23]JobForm:12="")
	OBJECT SET FONT STYLE:C166([Raw_Materials_Transactions:23]Raw_Matl_Code:1; 1)
	OBJECT SET FONT STYLE:C166([Raw_Materials_Transactions:23]POItemKey:4; 1)
	OBJECT SET FONT STYLE:C166([Raw_Materials:21]Flex5:23; 1)
Else 
	OBJECT SET FONT STYLE:C166([Raw_Materials_Transactions:23]Raw_Matl_Code:1; 0)
	OBJECT SET FONT STYLE:C166([Raw_Materials_Transactions:23]POItemKey:4; 0)
	OBJECT SET FONT STYLE:C166([Raw_Materials:21]Flex5:23; 0)
End if 

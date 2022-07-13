$po:=Request:C163("Enter the PO Nº:"; "000000000")
If (ok=1)
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Raw_Matl_Code:1=[Raw_Materials:21]Raw_Matl_Code:1; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]POItemKey:4=$po)
	ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3; >)
End if 
//
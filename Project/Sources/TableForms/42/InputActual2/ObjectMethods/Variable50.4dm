//bzSort: Sort Materials
QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms:42]JobFormID:5; *)
QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Location:15="WIP")

If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
	ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Sequence:13; >; [Raw_Materials_Transactions:23]Commodity_Key:22; >)
End if 
//EOP
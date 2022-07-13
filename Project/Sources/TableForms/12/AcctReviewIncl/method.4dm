app_SelectIncludedRecords(->[Purchase_Orders_Items:12]POItemKey:1; 0; "LINE")
$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		rPOPrice:=Round:C94([Purchase_Orders_Items:12]ExtPrice:11/[Purchase_Orders_Items:12]Qty_Shipping:4; 4)
		
		util_alternateBackground
		
		
		
	: ($e=On Clicked:K2:4)
		CUT NAMED SELECTION:C334([Purchase_Orders_Items:12]; "beforeHilite")
		
		USE SET:C118("clickedIncludeRecordLINE")
		$pokey:=[Purchase_Orders_Items:12]POItemKey:1
		USE NAMED SELECTION:C332("beforeHilite")
		HIGHLIGHT RECORDS:C656("clickedIncludeRecordLINE")
		
		CUT NAMED SELECTION:C334([Raw_Materials_Transactions:23]; "receipts")
		
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt"; *)
			QUERY:C277([Raw_Materials_Transactions:23];  | ; [Raw_Materials_Transactions:23]Xfer_Type:2="Return"; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]POItemKey:4=$pokey)
			SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]POItemKey:4; $poItemKeys)
			
			QUERY WITH ARRAY:C644([Raw_Materials_Transactions:23]POItemKey:4; $poItemKeys)
			CREATE SET:C116([Raw_Materials_Transactions:23]; "highlitedPO")
			
			
		Else 
			QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt"; *)
			QUERY:C277([Raw_Materials_Transactions:23];  | ; [Raw_Materials_Transactions:23]Xfer_Type:2="Return"; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]POItemKey:4=$pokey)
			SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]POItemKey:4; $poItemKeys)
			SET QUERY DESTINATION:C396(Into set:K19:2; "highlitedPO")
			QUERY WITH ARRAY:C644([Raw_Materials_Transactions:23]POItemKey:4; $poItemKeys)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
			
		End if   // END 4D Professional Services : January 2019 
		USE NAMED SELECTION:C332("receipts")
		HIGHLIGHT RECORDS:C656("highlitedPO")
		
End case 

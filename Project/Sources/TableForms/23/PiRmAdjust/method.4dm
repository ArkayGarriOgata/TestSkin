Case of 
	: (Form event code:C388=On Display Detail:K2:22) & (vDoc#?00:00:00?)
		C_TEXT:C284($xText)
		$xText:=[Raw_Materials_Transactions:23]Commodity_Key:22+Char:C90(9)+[Raw_Materials_Transactions:23]Raw_Matl_Code:1+Char:C90(9)+[Raw_Materials_Transactions:23]POItemKey:4+Char:C90(9)
		$xText:=$xText+String:C10([Raw_Materials_Transactions:23]Qty:6)+Char:C90(9)+[Raw_Materials_Transactions:23]Location:15+Char:C90(9)+String:C10([Raw_Materials_Transactions:23]ActExtCost:10)+Char:C90(13)
		SEND PACKET:C103(vDoc; $xText)
End case 
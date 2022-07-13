//(lp) [Fg_Transactions] PiFgAdjRpt
//created 3/11/97 cs upr 1858
Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		If (vDoc#?00:00:00?)
			C_TEXT:C284($xText)
			$xText:=[Finished_Goods_Transactions:33]XactionType:2+Char:C90(9)+String:C10([Finished_Goods_Transactions:33]XactionDate:3)+Char:C90(9)
			$xText:=$xText+[Finished_Goods_Transactions:33]ProductCode:1+Char:C90(9)+[Finished_Goods_Transactions:33]JobForm:5+Char:C90(9)
			$xText:=$xText+String:C10([Finished_Goods_Transactions:33]Qty:6)+Char:C90(9)+[Finished_Goods_Transactions:33]Location:9+Char:C90(9)
			$xText:=$xText+String:C10([Finished_Goods_Transactions:33]CoGSExtended:8)+Char:C90(9)+[Finished_Goods_Transactions:33]ModWho:18+Char:C90(13)
			SEND PACKET:C103(vDoc; $xText)
		End if 
End case 
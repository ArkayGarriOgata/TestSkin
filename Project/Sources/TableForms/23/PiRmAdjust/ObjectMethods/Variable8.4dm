Self:C308->:=Subtotal:C97([Raw_Materials_Transactions:23]ActExtCost:10)
If (vDoc#?00:00:00?)
	SEND PACKET:C103(vDoc; (Char:C90(9)*5)+"Total for Division: "+String:C10(Subtotal:C97([Raw_Materials_Transactions:23]Qty:6); "###,###,##0")+Char:C90(9)+String:C10(Self:C308->; "$###,###,##0")+Char:C90(13))
End if 
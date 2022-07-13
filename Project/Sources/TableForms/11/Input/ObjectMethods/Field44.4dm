If ([Purchase_Orders:11]Ordered:47)
	[Purchase_Orders:11]StatusTrack:51:="PO Ordered by "+<>zResp+" at "+TS2String(TSTimeStamp)+Char:C90(13)+[Purchase_Orders:11]StatusTrack:51
Else 
	[Purchase_Orders:11]StatusTrack:51:="PO Ordered uncheck by "+<>zResp+" at "+TS2String(TSTimeStamp)+Char:C90(13)+[Purchase_Orders:11]StatusTrack:51
End if 

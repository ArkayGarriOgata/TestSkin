//%attributes = {"publishedWeb":true}
//(p) uSaveFGLocation
C_DATE:C307($1)
If ((Record number:C243([Finished_Goods_Locations:35])>=0) | (Record number:C243([Finished_Goods_Locations:35])=-3))
	[Finished_Goods_Locations:35]ModDate:21:=$1
	[Finished_Goods_Locations:35]ModWho:22:=<>zResp
	SAVE RECORD:C53([Finished_Goods_Locations:35])
	UNLOAD RECORD:C212([Finished_Goods_Locations:35])
End if 
//
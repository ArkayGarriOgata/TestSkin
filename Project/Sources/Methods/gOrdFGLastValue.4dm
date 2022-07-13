//%attributes = {"publishedWeb":true}
//(p) gOrdLastValue `5/3/95 chip
//5/8/95 adjusted for upr 1489
//determine correct values to setup in last fields from orderline
//• 4/14/98 cs Nan checking

If (Records in selection:C76([Finished_Goods:26])=0)
	CREATE RECORD:C68([Finished_Goods:26])
End if 

FG_Cspec2FG(vord)

If (vord#0)
	[Finished_Goods:26]LastOrderNo:18:=vord
End if 
If ([Customers_Order_Lines:41]Price_Per_M:8#0)
	[Finished_Goods:26]LastPrice:27:=uNANCheck([Customers_Order_Lines:41]Price_Per_M:8)
End if 
If ([Customers_Order_Lines:41]Cost_Per_M:7#0)
	[Finished_Goods:26]LastCost:26:=uNANCheck([Customers_Order_Lines:41]Cost_Per_M:7)
End if 

SAVE RECORD:C53([Finished_Goods:26])
//%attributes = {"publishedWeb":true}
//(p) ReqCalcItmValue
//• 6/10/97 cs created upr 1872
//based on sCalcPoItems

If ([Purchase_Orders_Items:12]FactDship2price:38=0)  //this was #0 but i think that was a typo
	[Purchase_Orders_Items:12]FactDship2price:38:=1
End if 

If ([Purchase_Orders_Items:12]FactNship2price:25=0)
	[Purchase_Orders_Items:12]FactNship2price:25:=1
End if 
//added 12/28/94
If ([Purchase_Orders_Items:12]FactNship2cost:29=0)  //added 12/28/94
	[Purchase_Orders_Items:12]FactNship2cost:29:=1
End if 

If ([Purchase_Orders_Items:12]FactDship2cost:37=0)
	[Purchase_Orders_Items:12]FactDship2cost:37:=1
End if 

[Purchase_Orders_Items:12]Qty_Shipping:4:=Round:C94([Purchase_Orders_Items:12]Qty_Ordered:30*([Purchase_Orders_Items:12]FactNship2cost:29/[Purchase_Orders_Items:12]FactDship2cost:37); 3)
[Purchase_Orders_Items:12]Qty_Billing:17:=Round:C94([Purchase_Orders_Items:12]Qty_Shipping:4*[Purchase_Orders_Items:12]FactNship2price:25/[Purchase_Orders_Items:12]FactDship2price:38; 3)
[Purchase_Orders_Items:12]ExtPrice:11:=Round:C94([Purchase_Orders_Items:12]UnitPrice:10*[Purchase_Orders_Items:12]Qty_Billing:17; 3)
[Purchase_Orders_Items:12]Qty_Open:27:=[Purchase_Orders_Items:12]Qty_Shipping:4-[Purchase_Orders_Items:12]Qty_Received:14
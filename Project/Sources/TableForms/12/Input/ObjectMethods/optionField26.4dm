//• 6/30/98 cs inserted code to update conversions
fNewRM:=True:C214
[Purchase_Orders_Items:12]Qty_Shipping:4:=ConvertUnits(Self:C308->; [Purchase_Orders_Items:12]UM_Arkay_Issue:28; [Purchase_Orders_Items:12]UM_Ship:5; ->[Purchase_Orders_Items:12]FactNship2cost:29; ->[Purchase_Orders_Items:12]FactDship2cost:37)
[Purchase_Orders_Items:12]Qty_Billing:17:=ConvertUnits([Purchase_Orders_Items:12]Qty_Shipping:4; [Purchase_Orders_Items:12]UM_Ship:5; [Purchase_Orders_Items:12]UM_Price:24; ->[Purchase_Orders_Items:12]FactNship2price:25; ->[Purchase_Orders_Items:12]FactDship2price:38; "*")
ReqCalcItmValue
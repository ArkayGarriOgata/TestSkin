//(s) aUOM [poitems]input
[Purchase_Orders_Items:12]UM_Price:24:=Substring:C12(util_ComboBoxAction(->aUOM3; aUOM3{0}); 1; 4)
If (Length:C16([Purchase_Orders_Items:12]UM_Price:24)>0)
	r3:=ConvertFactor([Purchase_Orders_Items:12]UM_Price:24; [Purchase_Orders_Items:12]UM_Ship:5; ->[Purchase_Orders_Items:12]FactDship2price:38; ->[Purchase_Orders_Items:12]FactNship2price:25)
	CalcPOitem
	fNewRM:=True:C214
Else 
	[Purchase_Orders_Items:12]UM_Price:24:=Old:C35([Purchase_Orders_Items:12]UM_Price:24)
End if 
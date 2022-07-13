[Purchase_Orders_Items:12]UM_Ship:5:=Substring:C12(util_ComboBoxAction(->aUOM1; aUOM1{0}); 1; 4)  //(s) aUOM [poitems]input
If (Length:C16([Purchase_Orders_Items:12]UM_Ship:5)>0)  //• 6/16/97 cs made sure that a blank uom is not valid
	r3:=ConvertFactor([Purchase_Orders_Items:12]UM_Ship:5; [Purchase_Orders_Items:12]UM_Arkay_Issue:28; ->[Purchase_Orders_Items:12]FactNship2cost:29; ->[Purchase_Orders_Items:12]FactDship2cost:37)
	r3:=ConvertFactor([Purchase_Orders_Items:12]UM_Price:24; [Purchase_Orders_Items:12]UM_Ship:5; ->[Purchase_Orders_Items:12]FactDship2price:38; ->[Purchase_Orders_Items:12]FactNship2price:25)
	CalcPOitem
	fNewRM:=True:C214
Else 
	[Purchase_Orders_Items:12]UM_Ship:5:=Old:C35([Purchase_Orders_Items:12]UM_Ship:5)
End if 
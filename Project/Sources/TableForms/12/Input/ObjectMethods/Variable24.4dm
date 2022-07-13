//(s) aUOM [poitems]input
[Purchase_Orders_Items:12]UM_Arkay_Issue:28:=Substring:C12(util_ComboBoxAction(->aUOM2; aUOM2{0}); 1; 4)
If (Length:C16([Purchase_Orders_Items:12]UM_Arkay_Issue:28)>0)  //• 6/16/97 cs made sure that a blank uom is not valid  
	r3:=ConvertFactor([Purchase_Orders_Items:12]UM_Arkay_Issue:28; [Purchase_Orders_Items:12]UM_Ship:5; ->[Purchase_Orders_Items:12]FactNship2cost:29; ->[Purchase_Orders_Items:12]FactDship2cost:37)
	CalcPOitem
	fNewRM:=True:C214
Else 
	[Purchase_Orders_Items:12]UM_Arkay_Issue:28:=Old:C35([Purchase_Orders_Items:12]UM_Arkay_Issue:28)
End if 
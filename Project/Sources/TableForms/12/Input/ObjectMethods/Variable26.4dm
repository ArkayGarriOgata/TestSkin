//(s) aCommCode [poitems]input
[Purchase_Orders_Items:12]SubGroup:13:=Substring:C12(util_ComboBoxAction(->aSubgroup); 1; 20)

If (Length:C16([Purchase_Orders_Items:12]SubGroup:13)>0) & ([Purchase_Orders_Items:12]CommodityCode:16>0) & (iMode<3)
	POSubGroup
End if 
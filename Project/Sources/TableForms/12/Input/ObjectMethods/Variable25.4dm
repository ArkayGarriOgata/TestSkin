//(s) aCommCode [poitems]input
If (iMode<3)
	If (Length:C16(aCommCode{0})=1)
		aCommCode{0}:="0"+aCommCode{0}
	End if 
	[Purchase_Orders_Items:12]CommodityCode:16:=Num:C11(Substring:C12(util_ComboBoxAction(->aCommCode); 1; 2))
	If ([Purchase_Orders_Items:12]CommodityCode:16>0) & (iMode<3)
		POCommCode
		If ([Purchase_Orders_Items:12]CommodityCode:16=17)
			allow_supply_chain:=True:C214
		Else 
			allow_supply_chain:=False:C215
		End if 
		GOTO OBJECT:C206(aSubgroup)
	End if 
End if 
//

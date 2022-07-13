QUERY:C277([Raw_Material_Commodities:54]; [Raw_Material_Commodities:54]CommodityID:1=[y_accounting_dept_commodities:89]CommodityCode:1)
If (Records in selection:C76([Raw_Material_Commodities:54])>0)
	[y_accounting_dept_commodities:89]CommDesc:3:=[Raw_Material_Commodities:54]CommodityName:2
Else 
	BEEP:C151
	ALERT:C41("That is not a valid Commodity, add it to the [Commodities] table first.")
	[y_accounting_dept_commodities:89]CommodityCode:1:=0
End if 

$hit:=Find in array:C230(aCommCode; (String:C10([y_accounting_dept_commodities:89]CommodityCode:1; "00")+"@"))
If ($hit>-1)
	[y_accounting_dept_commodities:89]CommodityCode:1:=Num:C11(Substring:C12(aCommCode{$hit}; 1; 2))
	[y_accounting_dept_commodities:89]CommDesc:3:=Substring:C12(aCommCode{$hit}; 6)
End if 
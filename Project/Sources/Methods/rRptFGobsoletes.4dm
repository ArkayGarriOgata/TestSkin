//%attributes = {"publishedWeb":true}
//(P) mRptFG

uConfirm("Remember to check Bill&Hold Qty before scrapping!"; "Ok"; "Cancel")
If (ok=1)
	FORM SET OUTPUT:C54([Finished_Goods:26]; "Obsoletes")
	FG_setInventoryNow
	
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]Status:14="@obsolete@"; *)
	QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]InventoryNow:73>0)
	//uRelateSelect (->[Finished_Goods_Locations]ProductCode;->[Finished_Goods]ProductCode)
	//uRelateSelect (->[Finished_Goods]ProductCode;->[Finished_Goods_Locations]ProductCode)
	ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]CustID:2; >; [Finished_Goods:26]ProductCode:1; >)
	BREAK LEVEL:C302(1)
	ACCUMULATE:C303(r1)
	util_PAGE_SETUP(->[Finished_Goods:26]; "Obsoletes")
	PDF_setUp
	PRINT SELECTION:C60([Finished_Goods:26]; *)
	FORM SET OUTPUT:C54([Finished_Goods:26]; "List")
End if 
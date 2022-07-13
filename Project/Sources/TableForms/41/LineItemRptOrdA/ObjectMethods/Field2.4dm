//upr 1086 mod 3/24/94
QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=[Customers_Order_Lines:41]CustID:4+":"+[Customers_Order_Lines:41]ProductCode:5)
t16:=String:C10([Customers_Order_Lines:41]Price_Per_M:8; "###,###,##0.00")
If ([Finished_Goods:26]Acctg_UOM:29#"")
	t16:=t16+"/"+[Finished_Goods:26]Acctg_UOM:29
End if 
//If ([Finished_Goods]PackingQty#0)
// t16b:=String([Finished_Goods]PackingQty)+"/case"
//End if 
t16b:="PO Nº: "+[Customers_Order_Lines:41]PONumber:21
t15b:=String:C10([Customers_Order_Lines:41]OverRun:25; "+#0%; ; ")
t15c:=String:C10([Customers_Order_Lines:41]UnderRun:26; "-#0%; ; ")

rSqInch:=0
//FIRST SUBRECORD([Finished_Goods]LeafInformation)
//While (Not(End subselection([Finished_Goods]LeafInformation)))
//rSqInch:=rSqInch+([Finished_Goods]LeafInformation'Width*[Finished_Goods]LeafInformation'Lenth)
//NEXT SUBRECORD([Finished_Goods]LeafInformation)
//End while 
//EOP
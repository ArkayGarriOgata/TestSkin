//%attributes = {"publishedWeb":true}
//rRptScrappedFG    2/28/95

C_TEXT:C284($1)  //Value | Cost

t10:=$1
READ ONLY:C145([Finished_Goods:26])
READ ONLY:C145([Finished_Goods_Transactions:33])
READ ONLY:C145([Customers:16])
READ ONLY:C145([Job_Forms_Items:44])

QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9="Sc@")
If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
	util_PAGE_SETUP(->[Finished_Goods_Transactions:33]; "ItemsScrapped")
	FORM SET OUTPUT:C54([Finished_Goods_Transactions:33]; "ItemsScrapped")
	If (t10="COST")
		t2:="ITEMS SCRAPPED WITH $ AMOUNTS AT COST"
	Else 
		t2:="ITEMS SCRAPPED WITH $ AMOUNTS AT SALES VALUE"
	End if 
	
	t2b:="FROM "+String:C10(dDateBegin; 1)+" TO "+String:C10(dDateEnd; 1)
	t3:="Sorted by Customer and CPN"
	ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]CustID:12; >; [Finished_Goods_Transactions:33]ProductCode:1; >; [Finished_Goods_Transactions:33]Location:9; >)
	BREAK LEVEL:C302(1)
	ACCUMULATE:C303([Finished_Goods_Transactions:33]Qty:6; r1; r2; r3)
	MESSAGES OFF:C175
	PDF_setUp(<>pdfFileName)
	PRINT SELECTION:C60([Finished_Goods_Transactions:33]; *)
	MESSAGES ON:C181
	FORM SET OUTPUT:C54([Finished_Goods_Transactions:33]; "List")
End if 
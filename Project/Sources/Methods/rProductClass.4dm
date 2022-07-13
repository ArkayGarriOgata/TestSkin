//%attributes = {"publishedWeb":true}
//(p) rProductclass moved from mthendsuite

QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Ship"; *)
QUERY:C277([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="Return"; *)
QUERY:C277([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="RevShip"; *)  //10/11/94 upr 1269

QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd)

ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]FG_Classification:22; >)  //THIS stores hte class number

BREAK LEVEL:C302(1)
ACCUMULATE:C303([Finished_Goods_Transactions:33]Qty:6; rqty; real1; real2; real3; real4; real5; real6; real7; real8; real9; [Finished_Goods_Transactions:33]zCount:10)
util_PAGE_SETUP(->[Finished_Goods_Transactions:33]; "ClassSummary")
FORM SET OUTPUT:C54([Finished_Goods_Transactions:33]; "ClassSummary")
t2:="ANALYSIS OF SHIPPED SALES"
t2b:="COST OF SALES BY JOB; CLASS SUMMARY"
t3:="FROM "+String:C10(dDateBegin; 1)+" TO "+String:C10(dDateEnd; 1)
PDF_setUp(<>pdfFileName)
PRINT SELECTION:C60([Finished_Goods_Transactions:33]; *)
FORM SET OUTPUT:C54([Finished_Goods_Transactions:33]; "List")
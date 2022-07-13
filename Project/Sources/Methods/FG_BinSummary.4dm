//%attributes = {"publishedWeb":true}
//PM:  FG_BinSummary  11/03/00  mlb
//marty want Qty/Bin location every month

C_TEXT:C284(t1)

READ ONLY:C145([Finished_Goods_Locations:35])
ALL RECORDS:C47([Finished_Goods_Locations:35])
ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2; >)
t1:="Printed: "+TS2String(TSTimeStamp)

BREAK LEVEL:C302(1)
C_LONGINT:C283(i1; i2; iPage)
ACCUMULATE:C303([Finished_Goods_Locations:35]QtyOH:9; [Finished_Goods_Locations:35]zCount:18)
util_PAGE_SETUP(->[Finished_Goods_Locations:35]; "BinSummary")
FORM SET OUTPUT:C54([Finished_Goods_Locations:35]; "BinSummary")
PDF_setUp(<>pdfFileName)
PRINT SELECTION:C60([Finished_Goods_Locations:35]; *)

REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
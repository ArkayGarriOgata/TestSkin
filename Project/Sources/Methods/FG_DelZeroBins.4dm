//%attributes = {"publishedWeb":true}
//gDelZeroFgBins
//delete those fg bins which have zero items

QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]QtyOH:9>-1; *)
QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]QtyOH:9<1)  //use range to catch representation errors

utl_LogfileServer(<>zResp; "[Finished_Goods_Locations] Deleting zero bins, "+String:C10(Records in selection:C76([Finished_Goods_Locations:35]))+" records"; "PhyInv.log")

util_DeleteSelection(->[Finished_Goods_Locations:35])
//%attributes = {"publishedWeb":true}
//PM: ams_DeleteOldInvSummary() -> 
//@author mlb - 7/2/02  17:48

//C_DATE($cutOff;$1)
//$cutOff:=$1
//READ WRITE([Finished_Goods_Inv_Summaries])
//QUERY([Finished_Goods_Inv_Summaries];[Finished_Goods_Inv_Summaries]DateFrozen<$cutOff)
//util_DeleteSelection (->[Finished_Goods_Inv_Summaries])
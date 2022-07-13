// -------
// Method: [Finished_Goods_DeliveryForcasts].compare_dio.Variable16   ( ) ->
// By: Mel Bohince @ 01/15/19, 14:34:36
// Description
// 
// ----------------------------------------------------


uConfirm("Use the new option?"; "New"; "Old")
If (ok=1)
	ELC_findMissingOrders
Else 
	PnG_DeliveryScheduleReport
End if 
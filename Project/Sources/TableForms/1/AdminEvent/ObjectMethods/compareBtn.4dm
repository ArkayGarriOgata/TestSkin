// _______
// Method: [zz_control].AdminEvent.compareBtn   ( ) ->
// By: Mel Bohince @ 11/10/20, 10:24:32
// Description
// 
// ----------------------------------------------------


uConfirm("Compare aMs to WMS"; "Yes"; "Use Dialog")
If (ok=1)
	wms_compare_to_ams
	
Else 
	uConfirm("Open Compare Dialog"; "Yes"; "No")
	If (ok=1)
		WMS_v_AMS
	End if 
End if 

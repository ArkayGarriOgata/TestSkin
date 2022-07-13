wms_bin_id:=Uppercase:C13(wms_bin_id)
$amsBin:=wms_convert_bin_id("ams"; wms_bin_id)
If (sVerifyLocation(->$amsBin))
	OBJECT SET TITLE:C194(cbMoveOS; "Move "+String:C10(wms_qty_moved)+" from "+[Finished_Goods_Locations:35]Location:2+" to "+$amsBin)
	
Else 
	wms_bin_id:=""
End if 


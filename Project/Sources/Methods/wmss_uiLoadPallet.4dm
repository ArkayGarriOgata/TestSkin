//%attributes = {"publishedWeb":true}
//PM: wmss_uiLoadPallet() -> 
//@author Mel - 5/9/03  17:01


C_LONGINT:C283($1; $2; $3; $clickX; $clickY)
C_TEXT:C284(rft_prompt; rft_response; rft_state; rft_skid_label_id; rft_error_log; rft_log)

If (Count parameters:C259=2)
	$clickX:=$1
	$clickY:=$2
	$pid:=New process:C317("wmss_uiLoadPallet"; <>lMinMemPart; "WMS Build Skid"; $clickX; $clickY; 10)
	If (False:C215)
		wmss_uiLoadPallet
	End if 
	
Else 
	$clickX:=$1+$3
	$clickY:=$2-$3
	
	READ ONLY:C145([Job_Forms_Items:44])
	READ ONLY:C145([Finished_Goods:26])
	$winRef:=Open window:C153($clickX; $clickY; $clickX+750; $clickY+600; Plain form window:K39:10; "BUILD SKID"; "wCloseCancel")
	DIALOG:C40([WMS_SerializedShippingLabels:96]; "BuildSkid_dio")
	CLOSE WINDOW:C154($winRef)
End if 

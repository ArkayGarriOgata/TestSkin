//%attributes = {}

// Method: wmss_uiBinCheck ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/19/15, 11:58:22
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------

C_LONGINT:C283($1; $2; $3; $clickX; $clickY)
C_TEXT:C284(rft_prompt; rft_response; rft_state; rft_skid_label_id; rft_error_log; rft_log)

If (Count parameters:C259=2)
	$clickX:=$1
	$clickY:=$2
	$pid:=New process:C317("wmss_uiBinCheck"; <>lMinMemPart; "WMS Check"; $clickX; $clickY; 10)
	If (False:C215)
		wmss_uiBinCheck
	End if 
	
Else 
	$clickX:=$1+$3
	$clickY:=$2-$3
	
	$winRef:=Open window:C153($clickX; $clickY; $clickX+750; $clickY+600; Plain form window:K39:10; "LOOK UP"; "wCloseCancel")
	DIALOG:C40([WMS_SerializedShippingLabels:96]; "BinCheck_dio")
	CLOSE WINDOW:C154($winRef)
End if 

//%attributes = {}
// ----------------------------------------------------
// Method: wmss_uiMoveMulti   ( ) ->
// By: Mel Bohince @ 04/06/16, 14:01:18
// Description
// based on wmss_uiMove, difference being start with destination and 
// scan multiple items into that destination until done
// ----------------------------------------------------

C_LONGINT:C283($1; $2; $3; $clickX; $clickY)
C_TEXT:C284(rft_prompt; rft_response; rft_state; rft_skid_label_id; rft_error_log; rft_log)

If (Count parameters:C259=2)
	$clickX:=$1
	$clickY:=$2
	$pid:=New process:C317("wmss_uiMoveMulti"; <>lMinMemPart; "WMS Move"; $clickX; $clickY; 10)
	If (False:C215)
		wmss_uiMoveMulti
	End if 
	
Else 
	$clickX:=$1+$3
	$clickY:=$2-$3
	//CONFIRM("Bad things can happen, have you done a backup?";"Continue";"Cancel")  // Modified by: Mel Bohince (12/10/15) issue warning
	//If (ok=1)
	$winRef:=Open window:C153($clickX; $clickY; $clickX+750; $clickY+1015; Plain form window:K39:10; "MOVE CASE OR SKID"; "wCloseCancel")
	DIALOG:C40([WMS_SerializedShippingLabels:96]; "MoveMulti_dio")
	CLOSE WINDOW:C154($winRef)
	//End if 
End if 
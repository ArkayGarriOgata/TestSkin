
// Method: [WMS_SerializedShippingLabels].Input.Button3 ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 11/13/14, 15:39:40
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------

// Modified by: Mel Bohince (11/19/14) option to specify location
// Modified by: Mel Bohince (12/13/18) option to send O/S WIP loads so can be added to iBOL

$success:=wms_api_Send_Super_Case("init")

$insert_datetime:=wms_glued
$update_datetime:=4D_Current_date
$warehouse:="R"
If (Substring:C12([WMS_SerializedShippingLabels:96]HumanReadable:5; 1; 3)="000")  // Modified by: Mel Bohince (12/13/18) option to send O/S WIP loads so can be added to iBOL
	wms_bin_id:="BNRWIP"
	cbMoveOS:=0
Else 
	wms_bin_id:="BNRXC"
End if 
wms_bin_id:=Request:C163("Which location? BNRXC is XC:R"; wms_bin_id; "Send"; "Cancel")
If (ok=1)
	If (Length:C16(wms_bin_id)>4)
		$ams_location:=Substring:C12(wms_bin_id; 4; 2)
		$case_status_code:=100
		$jobit_stripped:=Replace string:C233([WMS_SerializedShippingLabels:96]Jobit:3; "."; "")
		$case_id:=[WMS_SerializedShippingLabels:96]HumanReadable:5  //having skid# for case# triggers super_case behavior
		$success:=wms_api_Send_Super_Case("insert"; [WMS_SerializedShippingLabels:96]HumanReadable:5; [WMS_SerializedShippingLabels:96]CreateDate:9; [WMS_SerializedShippingLabels:96]Quantity:4; $jobit_stripped; $case_status_code; $ams_location; wms_bin_id; $insert_datetime; $update_datetime; "aMs"; $warehouse; [WMS_SerializedShippingLabels:96]HumanReadable:5)
		
	Else 
		BEEP:C151
		uConfirm("Not saved, bin should be greater than 4 characters, like BNRXC"; "Ok"; "Cancel")
	End if 
End if 

$success:=wms_api_Send_Super_Case("kill")
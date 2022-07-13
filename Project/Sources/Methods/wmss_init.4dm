//%attributes = {}

// Method: wmss_init ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/09/15, 11:44:39
// ----------------------------------------------------
// Description
// descide what to do with value just entered
//
// ----------------------------------------------------
C_TEXT:C284($1)
C_BOOLEAN:C305($0)

If (Count parameters:C259>0)
	rft_log:=$1
Else 
	rft_log:="Begin by scanning pallet barcode, \rthen scan each case until standard\rcase count is reached.\r"
	rft_log:=rft_log+"(Re)scan pallet barcode to finish a partial skid. Enter 'Done' to quit."
End if 

rft_prompt:="Scan Skid Label: "
rft_response:=""
rft_state:="SKID"
rft_skid_label_id:=""
rft_error_log:=""
scan_number:=0
std_skid_count:=0
std_case_count:=0
std_cases_skid:=0
sJobit:=""
ARRAY TEXT:C222(rft_scanNumber; 0)
ARRAY TEXT:C222(rft_caseNumber; 0)
ARRAY TEXT:C222(rft_scansSoFar; 0)
<>WMS_ERROR:=0


SET WINDOW TITLE:C213(rft_state)
zwStatusMsg("BUILD SKID"; "Scan pallet label, cases, then end by rescanning the pallet label")
$0:=True:C214

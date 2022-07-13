//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/26/06, 11:02:44
// ----------------------------------------------------
// Method: Estimate_DupDiff($NewDiffID;tag;processspec)

// ----------------------------------------------------

C_TEXT:C284($1; $2; $3; $newDiffID; $tag)

$newDiffID:=$1
$tag:=$2

DUPLICATE RECORD:C225([Estimates_Differentials:38])
[Estimates_Differentials:38]pk_id:46:=Generate UUID:C1066
[Estimates_Differentials:38]Id:1:=$newDiffID
[Estimates_Differentials:38]diffNum:3:=Substring:C12($newDiffID; 10)
[Estimates_Differentials:38]PSpec_Qty_TAG:25:=$tag
If (Count parameters:C259=3)
	[Estimates_Differentials:38]ProcessSpec:5:=$3
End if 
// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_Differentials]z_SYNC_ID;->[Estimates_Differentials]z_SYNC_DATA)
SAVE RECORD:C53([Estimates_Differentials:38])
//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getBinDetailSummary - Created v0.1.0-JJG (05/13/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($0; $xlNumRows; $i; $xlQty; $xlSkidCases)
C_TEXT:C284($1; $2; $ttLocation; $ttJobit; $ttSQL; $ttJobitWMS)
ARRAY LONGINT:C221($sxlCaseCount; 0)
ARRAY LONGINT:C221($sxlQuantity; 0)
ARRAY TEXT:C222($sttSkidNums; 0)
ARRAY TEXT:C222($sttBinIDs; 0)
$ttLocation:=$1
$ttJobit:=$2
$xlNumRows:=0

$ttJobitWMS:=Replace string:C233($ttJobit; "."; "")
$ttSQL:="SELECT COUNT(case_id),SUM(qty_in_case),skid_number,bin_id FROM cases WHERE bin_id=? AND jobit=? GROUP BY skid_number,bin_id ORDER BY bin_id ASC"
SQL SET PARAMETER:C823($ttLocation; SQL param in:K49:1)
SQL SET PARAMETER:C823($ttJobitWMS; SQL param in:K49:1)
SQL EXECUTE:C820($ttSQL; $sxlCaseCount; $sxlQuantity; $sttSkidNums; $sttBinIDs)

If (OK=1)
	If (Not:C34(SQL End selection:C821))
		SQL LOAD RECORD:C822(SQL all records:K49:10)
	End if 
	SQL CANCEL LOAD:C824
	$xlNumRows:=Size of array:C274($sxlCaseCount)
	
	If ($xlNumRows>0)
		$xlQty:=0
		$xlSkidCases:=0
		//Case Id                 Skid Id               Bin Id  Case Qty
		utl_LogIt("SUMMARY:")
		utl_LogIt("Skid Id               Bin Id              Cases   Quantity")
		For ($i; 1; $xlNumRows)
			utl_LogIt($sttSkidNums{$i}+"  "+txt_Pad($sttBinIDs{$i}; " "; 1; 20)+"  "+String:C10($sxlCaseCount{$i}; "^^^")+"  "+String:C10($sxlQuantity{$i}; "^,^^^,^^0"))
			$xlQty:=$xlQty+$sxlCaseCount{$i}
			$xlSkidCases:=$xlSkidCases+$sxlQuantity{$i}
		End for 
		utl_LogIt(" === ")
		utl_LogIt("   "+String:C10($xlQty)+" cases on "+String:C10($xlNumRows)+" skids totaling "+String:C10($xlSkidCases)+" cartons")
		utl_LogIt(" ### ")
		utl_LogIt(" ### ")
		utl_LogIt("DETAIL ")
	End if 
End if 

$0:=$xlNumRows
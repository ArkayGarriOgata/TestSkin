//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getBinDetailList - Created v0.1.0-JJG (05/13/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($0; $3; $xlNumRows; $xlAskMeOnHandyQty; $xlQty)
C_TEXT:C284($1; $2; $ttSQL; $ttLocation; $ttJobit; $ttSQL; $ttCurrentSkid; $ttJobitWMS)
ARRAY TEXT:C222($sttSkidNums; 0)
ARRAY TEXT:C222($sttBinIDs; 0)
ARRAY TEXT:C222($sttCaseIDs; 0)
ARRAY LONGINT:C221($sxlCaseQty; 0)
ARRAY LONGINT:C221($sxlCaseStatusCode; 0)
$ttLocation:=$1
$ttJobit:=$2
$xlAskMeOnHandyQty:=$3
$xlNumRows:=0

$ttJobitWMS:=Replace string:C233($ttJobit; "."; "")
$ttSQL:="SELECT case_id,qty_in_case,skid_number,bin_id,case_status_code FROM cases WHERE jobit=? AND bin_id=?"
SQL SET PARAMETER:C823($ttJobitWMS; SQL param in:K49:1)
SQL SET PARAMETER:C823($ttLocation; SQL param in:K49:1)
SQL EXECUTE:C820($ttSQL; $sttCaseIDs; $sxlCaseQty; $sttSkidNums; $sttBinIDs; $sxlCaseStatusCode)

If (OK=1)
	If (Not:C34(SQL End selection:C821))
		SQL LOAD RECORD:C822(SQL all records:K49:10)
	End if 
	SQL CANCEL LOAD:C824
	
	$xlNumRows:=Size of array:C274($sttCaseIDs)
	$ttLocation:="in location = "+$ttLocation+" for jobit = "+$ttJobit
	$xlQty:=WMS_API_4D_getBinJobitCases($ttLocation; ->$sttSkidNums; ->$sttBinIDs; ->$sttCaseIDs; ->$sxlCaseQty; ->$sxlCaseStatusCode)
	WMS_API_4D_getBinDetailList_Fix($xlAskMeOnHandyQty; $xlQty)
	
	
End if 

If ($xlNumRows=0)
	uConfirm("No case were found for "+[Finished_Goods_Locations:35]Jobit:33+" in "+[Finished_Goods_Locations:35]Location:2; "OK"; "Help")
End if 

$0:=$xlNumRows
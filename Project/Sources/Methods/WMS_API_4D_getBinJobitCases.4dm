//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getBinJobitCases - Created v0.1.0-JJG (05/13/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($0; $xlQty; $i; $xlNumRows; $xlSkidCases; $xlSkidQty)
C_TEXT:C284($1; $ttLocation; $ttLastSkid)
C_POINTER:C301($2; $3; $4; $5; $6; $psttSkidNums; $psttBinIDs; $psttCaseIDs; $psxlCaseQty; $psxlCaseStatusCode)
$ttLocation:=$1
$psttSkidNums:=$2
$psttBinIDs:=$3
$psttCaseIDs:=$4
$psxlCaseQty:=$5
$psxlCaseStatusCode:=$6

$xlNumRows:=Size of array:C274($psttCaseIDs->)
MULTI SORT ARRAY:C718($psttSkidNums->; >; $psttCaseIDs->; >; $psttBinIDs->; >; $psxlCaseQty->; >; $psxlCaseStatusCode->; >)
utl_LogIt("Case Id                 Bin Id     Case Qty    State")

$ttLastSkid:=""
For ($i; 1; $xlNumRows)
	If ($psttSkidNums->{$i}#$ttLastSkid)
		If ($i#1)
			utl_LogIt(String:C10($xlSkidCases)+" cases on skid "+$ttLastSkid+"  "+String:C10($xlSkidQty)+" qty on skid")
			utl_LogIt(" --- ")
		End if 
		$ttLastSkid:=$psttSkidNums->{$i}
		$xlSkidCases:=0
		$xlSkidQty:=0
	End if 
	
	utl_LogIt($psttCaseIDs->{$i}+"  "+$psttBinIDs->{$i}+"  "+String:C10($psxlCaseQty->{$i})+wmss_CaseState($psxlCaseStatusCode->{$i}))
	$xlQty:=$xlQty+$psxlCaseQty->{$i}
	$xlSkidCases:=$xlSkidCases+1
	$xlSkidQty:=$xlSkidQty+$psxlCaseQty->{$i}
End for 

utl_LogIt(String:C10($xlSkidCases)+" cases on skid "+$ttLastSkid+"  "+String:C10($xlSkidQty)+" qty on skid")
utl_LogIt(" --- ")

utl_LogIt(String:C10($xlNumRows)+"  total cases    "+String:C10($xlQty)+" total qty "+$ttLocation)
utl_LogIt("show"; 0; sCPN+"-"+selectedJobit)
utl_LogIt("init")

$0:=$xlQty
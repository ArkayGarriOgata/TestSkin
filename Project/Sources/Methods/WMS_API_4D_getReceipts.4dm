//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getReceipts - Created v0.1.0-JJG (05/16/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($0; $xlAggregates; $xlTransactionCode; $xlCases)
C_TEXT:C284($ttSQL)
C_BOOLEAN:C305($fBreak)
$xlAggregates:=0
$xlTransactionCode:=100
$fBreak:=False:C215

READ WRITE:C146([WMS_aMs_Exports:153])

If (WMS_API_4D_DoLogin)
	
	//Next, mark all S to T
	WMS_API_4D_GetReceiptsUpdate
	
	$xlAggregates:=WMS_API_4D_getReceipts_Agg  // Process all T's
	If ($xlAggregates>0)
		WMS_API_4D_getReceipts_AggUpdat  // mark all T's to S's
	End if 
	
	
	WMS_API_4D_DoLogout
End if 

$0:=$xlAggregates
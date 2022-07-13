//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getJobitDetail - Created v0.1.0-JJG (05/13/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($0; $xlNumRows; $xlActualJobitQty)
C_TEXT:C284($ttJobit)


If (WMS_API_4D_getJobitDetSet("check"))
	<>WMS_ERROR:=0
	
	If (WMS_API_4D_DoLogin)
		
		WMS_API_4D_getJobitDetSet("get")
		
		$ttJobit:=[Job_Forms_Items:44]Jobit:4
		selectedJobit:=$ttJobit
		$xlActualJobitQty:=[Job_Forms_Items:44]Qty_Actual:11
		
		$xlNumRows:=WMS_API_4D_getJobitDetSummary($ttJobit)
		$xlNumRows:=WMS_API_4D_getJobitDetList($ttJobit; $xlActualJobitQty)
		
		WMS_API_4D_getJobitDetSet("clear")
		WMS_API_4D_DoLogout
	Else 
		uConfirm("Could not connect to WMS database."; "OK"; "Help")
		
	End if 
Else 
	uConfirm("Please select a Job_Forms_Item record to show bins."; "OK"; "Help")
	
End if 

$0:=$xlNumRows
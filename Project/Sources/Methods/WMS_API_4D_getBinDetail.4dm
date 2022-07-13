//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getBinDetail - Created v0.1.0-JJG (05/13/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($0; $xlNumRows; $i; $xlAskMeOnHandQty; $xlQty; $xlSkidCases)
C_TEXT:C284($ttSelectionSetName; $ttHoldCutSel; $ttSQL; $ttJobit; $ttLocation)
ARRAY TEXT:C222($sttSkidNums; 0)

If (WMS_API_4D_getBinDetailSet("check"))
	<>WMS_ERROR:=0
	
	If (WMS_API_4D_DoLogin)
		WMS_API_4D_getBinDetailSet("get")
		
		utl_LogIt("init")
		
		$ttJobit:=[Finished_Goods_Locations:35]Jobit:33
		$ttLocation:=wms_convert_bin_id("wms"; [Finished_Goods_Locations:35]Location:2)
		$xlAskMeOnHandQty:=[Finished_Goods_Locations:35]QtyOH:9
		
		$xlNumRows:=WMS_API_4D_getBinDetailSummary($ttLocation; $ttJobit)
		$xlNumRows:=WMS_API_4D_getBinDetailList($ttLocation; $ttJobit; $xlAskMeOnHandQty)
		
		WMS_API_4D_getBinDetailSet("clear")
		
		WMS_API_4D_DoLogout
	Else 
		uConfirm("Could not connect to WMS database."; "OK"; "Help")
		
	End if 
	
Else 
	uConfirm("Please select a Location record to show bins."; "OK"; "Help")
	
End if 

$0:=$xlNumRows
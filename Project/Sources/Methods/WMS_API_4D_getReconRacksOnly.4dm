//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getReconRacksOnly - Created v0.1.0-JJG (05/18/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($xlNumJobits)
ARRAY TEXT:C222($sttCaseJobits; 0)
<>WMS_ERROR:=0

READ WRITE:C146([Finished_Goods_Locations:35])
READ ONLY:C145([Job_Forms_Items:44])

If (WMS_API_4D_DoLogin)
	$xlNumJobits:=WMS_API_4D_getRecon_GetJobits(->$sttCaseJobits)
	
	If ($xlNumJobits>0)
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG@"; *)
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Tier:39>0)
		util_DeleteSelection(->[Finished_Goods_Locations:35])
		
		uThermoInit($xlNumJobits; "Reconciling Inventory")
		For ($i; 1; $xlNumJobits)
			WMS_API_4D_getRecon_DoJobit($sttCaseJobits{$i}; "Racks-Only")
			uThermoUpdate($i)
			
		End for 
		uThermoClose
		
	Else 
		uConfirm("Could not get a list of jobits from the cases table. "; "OK"; "Help")
	End if 
	
	WMS_API_4D_DoLogout
Else 
	uConfirm("Could not connect to WMS database."; "OK"; "Help")
End if 

UNLOAD RECORD:C212([Finished_Goods_Locations:35])
//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getRecon - Created v0.1.0-JJG (05/18/16)
// Modified by: Mel Bohince (1/22/18) don't perserve lost

If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 
C_BOOLEAN:C305($fClearZeros)
C_LONGINT:C283($i; $xlNumJobits)
ARRAY TEXT:C222($sttCaseJobits; 0)
$fClearZeros:=False:C215
<>WMS_ERROR:=0

READ WRITE:C146([Finished_Goods_Locations:35])
READ ONLY:C145([Job_Forms_Items:44])

If (WMS_API_4D_DoLogin)
	$xlNumJobits:=WMS_API_4D_getRecon_GetJobits(->$sttCaseJobits)
	
	If ($xlNumJobits>0)
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2#"@AV@"; *)  //consignment
		// Modified by: Mel Bohince (1/22/18) don't perserve lost, as the : below
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2#"@:OS@")  //outside service Modified by: Mel Bohince (12/18/15) fg: is now FG:OS@// Modified by: Mel Bohince (12/17/14)  also protect FG: which is outside service locations
		util_DeleteSelection(->[Finished_Goods_Locations:35])
		
		uThermoInit($xlNumJobits; "Reconciling Inventory")
		For ($i; 1; $xlNumJobits)
			WMS_API_4D_getRecon_DoJobit($sttCaseJobits{$i})
			uThermoUpdate($i)
			
		End for 
		uThermoClose
		
		If ($fClearZeros)  //now get rid of anything not found
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]QtyOH:9=0)
			util_DeleteSelection(->[Finished_Goods_Locations:35])
		End if 
		
	Else 
		uConfirm("Could not get a list of jobits from the cases table. "; "OK"; "Help")
	End if 
	
	WMS_API_4D_DoLogout
Else 
	uConfirm("Could not connect to WMS database."; "OK"; "Help")
End if 

UNLOAD RECORD:C212([Finished_Goods_Locations:35])
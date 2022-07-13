//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 07/20/10, 14:33:34
// ----------------------------------------------------
// Method: wms_start_from_menu
// ----------------------------------------------------
// Modified by: Mel Bohince (8/30/21) change stack to <>lBigMemPart

If (Current user:C182="Administrator")  //Modified by: Mark Zinke (11/19/12) Removed (Current user="Designer") |
	C_LONGINT:C283(<>WMS_GET_PID)
	C_BOOLEAN:C305(<>run_wms)
	<>WMS_GET_PID:=Process number:C372("wms_api_Get_Process")
	If (<>WMS_GET_PID=0)  //fire it up
		C_TEXT:C284($r)
		$r:=Char:C90(13)
		$msg:="Poling for WMS to aMs Transactions"+$r
		$msg:=$msg+"Mode = "+" Loop"+$r
		$msg:=$msg+"Interval = "+String:C10(2)+" minutes"+$r
		$msg:=$msg+"Transactions = "+" All "+$r
		//util_FloatingAlert ($msg)
		<>run_wms:=True:C214
		zwStatusMsg("WMS_GET"; " All "+" transactions, every "+String:C10(2)+" minutes")
		<>WMS_GET_PID:=New process:C317("wms_api_Get_Process"; <>lBigMemPart; "wms_api_Get_Process"; 60*60*2; "All")
		If (False:C215)
			wms_api_Get_Process
		End if 
		
	Else 
		
		If (Not:C34(<>fQuit4D))  // Added by: Mel Bohince (5/30/19) 
			uConfirm("wms_api_Get_Process is already running on this client."; "Just Checking"; "Kill")
			If (ok=0)  //kill
				<>run_wms:=False:C215
			End if 
			
		Else   //help it die
			<>run_wms:=False:C215
		End if 
	End if 
	
Else 
	BEEP:C151
	uConfirm("Not Administrator, ehh?"; "Ohh"; "Well then")  // Modified by: Mark Zinke (11/19/12) Removed "Designer or "
End if 
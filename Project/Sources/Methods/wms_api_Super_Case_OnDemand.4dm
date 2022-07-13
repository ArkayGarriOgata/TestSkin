//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 01/31/09, 09:32:58
// ----------------------------------------------------
// Method: wms_api_Super_Case_OnDemand
// Description
// offer to print supercase labels and insert into wms on demand,
// specifically for o/s gluing and returns
//trying to piggy back on the variables already entered in transfer dialogs
//
// Parameters
// ----------------------------------------------------


If (wms_api_Send_Super_Case("init"))
	
	
	
	
	
Else 
	uConfirm("Problem connecting to WMS"; "Try Later"; "Dang")
End if 
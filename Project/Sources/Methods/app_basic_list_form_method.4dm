//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/01/06, 15:01:23
// ----------------------------------------------------
// Method: app_basic_list_form_method
// Description
// respond to On Display Detail and On Close Box consistently
// ----------------------------------------------------

C_LONGINT:C283($event)

$event:=Form event code:C388

Case of 
	: ($event=On Display Detail:K2:22)
		util_alternateBackground
		
	: ($event=On Close Box:K2:21)
		CANCEL:C270
		bDone:=1
		
End case 
//%attributes = {}
// _______
// Method: app_LockedRecordBrowser   ( ) ->
// By: Mel Bohince @ 01/16/20, 14:04:19
// Description
// 
// ----------------------------------------------------

C_TEXT:C284($1)

If (Count parameters:C259=0)
	$pid_:=New process:C317("app_LockedRecordBrowser"; <>lMidMemPart; "LockedRecordBrowser"; "init")
	If (False:C215)
		app_LockedRecordBrowser
	End if 
	
Else 
	Case of 
		: ($1="init")
			SET MENU BAR:C67(<>defaultMenu)
			C_LONGINT:C283(iBagTabs)
			$winRef:=Open form window:C675("LockedRecords"; Plain form window:K39:10)
			DIALOG:C40("LockedRecords")
			CLOSE WINDOW:C154($winRef)
			<>pid_:=0
	End case 
End if 
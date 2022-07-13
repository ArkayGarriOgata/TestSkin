//%attributes = {}
// _______
// Method: PS_JustInTime   ( ) ->
// By: Mel Bohince @ 06/03/21, 15:35:39
// Description
// delay instanciating menu and pids until needed
// ----------------------------------------------------

If (Length:C16(<>psOUTSIDE_SERVICE_MENU)=0)  //set in uInitInterPrsVar
	$err:=PS_pid_mgr("init")
	$err:=PS_menu_mgr("init")
End if 

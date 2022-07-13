//%attributes = {}

// Method: THC_start_from_menu ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/26/14, 13:27:52
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------

If (Current user:C182="Administrator") | (Current user:C182="Designer")
	$server_pid:=Process number:C372("THC_Updater"; *)
	If ($server_pid=0)
		$server_pid:=Execute on server:C373("THC_request_update"; <>lMinMemPart; "THC_Updater"; "init")
	End if 
End if 


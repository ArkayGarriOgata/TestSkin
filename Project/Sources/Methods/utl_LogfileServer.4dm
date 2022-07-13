//%attributes = {}
// -------
// Method: utl_LogfileServer   ( who ; what) ->
// By: Mel Bohince @ 05/05/17, 08:55:08
// Description
// send msg to logfile on the server
// ----------------------------------------------------

C_TEXT:C284($who; $1; $2; $msg; $3; $logname)
C_LONGINT:C283($pid)

$who:=Change string:C234("    "; $1; 1)  //pad the users intials
$msg:=$who+" - "+$2
If (Count parameters:C259>2)
	$logname:=$3
Else 
	$logname:="wiretap.log"
End if 

$pid:=Execute on server:C373("utl_Logfile"; 0; "rpc:utl_Logfile"; $logname; $msg)

If (False:C215)  // for searching
	utl_Logfile
End if 
//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 11/10/11, 12:06:57
// ----------------------------------------------------
// Method: app_CleanKill
// Description:
// See if stored procedure died as instructed
//
// Parameters:
// $1=process name
// ----------------------------------------------------

C_TEXT:C284($1)
C_LONGINT:C283($pid)

$pid:=Process number:C372($1; *)
If ($pid=0)
	$success:="dead"
Else 
	$success:="ALIVE:"+String:C10(Process state:C330($pid))
End if 

utl_Logfile("server.log"; "Process: "+$1+" is "+$success)
//%attributes = {}

// Method: PSG_GlueSchedule ( which gluer | all )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/25/14, 13:55:31
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------
C_LONGINT:C283($winRef; $rtn_value; $num_master_rows)
C_TEXT:C284($1)
C_TEXT:C284(lastServerUpdate)

If (Count parameters:C259=1)
	gluer_id:=$1
Else 
	gluer_id:="ALLGluers"
End if 

READ ONLY:C145([Customers:16])
READ ONLY:C145([Salesmen:32])
READ ONLY:C145([Finished_Goods_Classifications:45])


PSG_ServerArrays  //this will init the server-side arrays and bring'em back home, see the "init" case in particular
$num_master_rows:=PSG_MasterArray("sizeOf")
If ($num_master_rows>0)  //make sure the exchange worked
	lastServerUpdate:=TS2String(TSTimeStamp)  //String(Current time;HH MM)
	$rtn_value:=PSG_LocalArray("new")
	$rtn_value:=PSG_LocalArray("size"; $num_master_rows)
	$rtn_value:=PSG_LocalArray("load")  // we be styling ;-)
	
	SET MENU BAR:C67("Scheduling_full")
	tWindowTitle:="Glue Schedule: "+gluer_id
	$winRef:=OpenFormWindow(->[ProductionSchedules:110]; "GlueSchedule"; ->tWindowTitle; tWindowTitle)
	DIALOG:C40([ProductionSchedules:110]; "GlueSchedule")
	CLOSE WINDOW:C154($winRef)
	
	$pid:=PS_pid_mgr("setpid"; gluer_id; 0)
	$winRef:=PS_pid_mgr("setwin"; gluer_id; 0)
	
Else 
	BEEP:C151
	ALERT:C41("There was a time-out while trying to load the open jobits."; "Try Later")
End if 
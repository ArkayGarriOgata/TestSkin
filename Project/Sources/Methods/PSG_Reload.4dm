//%attributes = {}

// Method: PSG_Reload ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/03/14, 15:46:58
// ----------------------------------------------------
// Description
// go get fresh copy of the arrays
//
// ----------------------------------------------------

C_LONGINT:C283($num_master_rows; $rtn_value)

$num_master_rows:=PSG_MasterArray("dispose")
PSG_ServerArrays("reload")
DELAY PROCESS:C323(Current process:C322; 30)  //wait a second for server to process

$num_master_rows:=PSG_MasterArray("sizeOf")
If ($num_master_rows>0)  //make sure the exchange worked
	lastServerUpdate:=TS2String(TSTimeStamp)  //String(Current time;HH MM)
	$rtn_value:=PSG_LocalArray("new")
	$rtn_value:=PSG_LocalArray("size"; $num_master_rows)
	$rtn_value:=PSG_LocalArray("load")  // we be styling ;-)
	
	numRecs:=PSG_ApplySettingOptions(psg_progress; psg_assignments; psg_timeing)
	
	If (gluer_id="ALLGluers")
		PSG_LocalArray("sort"; 1)  //by release date
	Else 
		PSG_LocalArray("sort"; 2)  //by priority
	End if 
	
	REDRAW:C174(aGlueListBox)
	zwStatusMsg("Refreshed"; String:C10(Current time:C178))
	
Else 
	BEEP:C151
	BEEP:C151
	
End if 

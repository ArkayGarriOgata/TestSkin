// -------
// Method: [zz_control].JobsEvent.kanban   ( ) ->
// By: Mel Bohince @ 02/04/19, 15:59:22
// Description
// 
// ----------------------------------------------------
uConfirm("Kanban by Sheets or Pallets?"; "Sheets"; "Pallets")
If (ok=1)
	$pid:=uSpawnProcess("Job_WIP_Kanban"; <>lMinMemPart; "Kanban Rpt")
Else 
	$pid:=uSpawnProcess("Job_WIP_Kanban_Skid_Count"; <>lMinMemPart; "Kanban Rpt")
End if 

If (False:C215)
	Job_WIP_Kanban
	Job_WIP_Kanban_Skid_Count
End if 
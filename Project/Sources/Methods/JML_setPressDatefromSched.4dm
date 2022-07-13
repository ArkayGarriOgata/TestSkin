//%attributes = {"publishedWeb":true}
//PM: JML_setPressDatefromSched() -> 
//@author mlb - 12/7/01  16:09
// Removed RM_AllocationSchedule by: MelvinBohince (3/28/22) date now set by batched RM_AllocationSetDate_eos called by Batch_RM_Allocations

C_TEXT:C284($1)

If (Count parameters:C259=0)
	ARRAY LONGINT:C221($_hold; 0)  //<>modification4D_25_03_19
	LONGINT ARRAY FROM SELECTION:C647([ProductionSchedules:110]; $_hold)
	PS_qryPrintingOnly
	
Else 
	READ ONLY:C145([ProductionSchedules:110])
	PS_qryPrintingOnly
End if 

ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]StartDate:4; <)  //latest to earliest<>modification4D_14_01_19

READ WRITE:C146([Job_Forms_Master_Schedule:67])
While (Not:C34(End selection:C36([ProductionSchedules:110])))
	If ([ProductionSchedules:110]StartDate:4#!00-00-00!)
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=(Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8)))
		If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
			$updatePressId:=Position:C15([ProductionSchedules:110]CostCenter:1; [Job_Forms_Master_Schedule:67]Operations:36)
			If ($updatePressId=0)
				[Job_Forms_Master_Schedule:67]Operations:36:=[Job_Forms_Master_Schedule:67]Operations:36+" "+[ProductionSchedules:110]CostCenter:1
				SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
			End if 
			If ([Job_Forms_Master_Schedule:67]PressDate:25#[ProductionSchedules:110]StartDate:4)
				[Job_Forms_Master_Schedule:67]PressDate:25:=[ProductionSchedules:110]StartDate:4
				[Job_Forms_Master_Schedule:67]DD_FinalOks:24:=[Job_Forms_Master_Schedule:67]PressDate:25-5
				If ([Job_Forms_Master_Schedule:67]GateWayDeadLine:42=!00-00-00!) & (False:C215)  // • mel (11/9/04, 15:52:35)disabled
					[Job_Forms_Master_Schedule:67]GateWayDeadLine:42:=[Job_Forms_Master_Schedule:67]PressDate:25-(7*2)
				End if 
				[Job_Forms_Master_Schedule:67]WeekNumber:38:=util_weekNumber([Job_Forms_Master_Schedule:67]PressDate:25)
				SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
				
				// Removed by: MelvinBohince (3/28/22) date now set by batched RM_AllocationSetDate_eos called by Batch_RM_Allocations
				//$i:=RM_AllocationSchedule ([Job_Forms_Master_Schedule]JobForm;([Job_Forms_Master_Schedule]PressDate-1))
				
				zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods:26])+" file. Please Wait...")
				READ WRITE:C146([Finished_Goods:26])
				QUERY:C277([Finished_Goods:26]; [Job_Forms_Items:44]JobForm:1=[Job_Forms_Master_Schedule:67]JobForm:4)  //<>modification4D_14_01_19
				zwStatusMsg(""; "")
				
				REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
				$numFGs:=Records in selection:C76([Finished_Goods:26])
				ARRAY DATE:C224($pressDate; $numFGs)
				For ($i; 1; $numFGs)
					$pressDate{$i}:=[Job_Forms_Master_Schedule:67]PressDate:25
				End for 
				ARRAY TO SELECTION:C261($pressDate; [Finished_Goods:26]PressDate:64)
				
				READ WRITE:C146([To_Do_Tasks:100])
				QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]Jobform:1=([Job_Forms_Master_Schedule:67]JobForm:4+"@"))
				ARRAY DATE:C224($pressDate; 0)
				$numFGs:=Records in selection:C76([To_Do_Tasks:100])
				ARRAY DATE:C224($pressDate; $numFGs)
				For ($i; 1; $numFGs)
					$pressDate{$i}:=[Job_Forms_Master_Schedule:67]GateWayDeadLine:42  // • mel (11/9/04, 15:52:35)was press date
				End for 
				ARRAY TO SELECTION:C261($pressDate; [To_Do_Tasks:100]DateDue:10)
				
			End if 
		End if   //jml found
	End if   //not 00/00    
	NEXT RECORD:C51([ProductionSchedules:110])
End while 

If (Count parameters:C259=0)
	CREATE SELECTION FROM ARRAY:C640([ProductionSchedules:110]; $_hold)  //<>modification4D_25_03_19
	
Else 
	REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
End if 
//%attributes = {"publishedWeb":true}
//PM: JML_OnValidateForm() -> 
//@author mlb - 7/17/01  12:59
// Modified by: Mel Bohince (3/18/18) send HRD date to PF, not yes/no
// Removed RM_AllocationSchedule by: MelvinBohince (3/28/22) date now set by batched RM_AllocationSetDate_eos called by Batch_RM_Allocations

zwStatusMsg("Job Mstr Log"; "Saving record "+[Job_Forms_Master_Schedule:67]JobForm:4)
[Job_Forms_Master_Schedule:67]ModificationBy:76:=<>zResp
[Job_Forms_Master_Schedule:67]ModificationDate:73:=4D_Current_date
[Job_Forms_Master_Schedule:67]ModificationTime:74:=4d_Current_time
$numFGs:=Records in selection:C76([Finished_Goods:26])
ARRAY DATE:C224($pressDate; $numFGs)
For ($i; 1; $numFGs)
	$pressDate{$i}:=[Job_Forms_Master_Schedule:67]PressDate:25
End for 
ARRAY TO SELECTION:C261($pressDate; [Finished_Goods:26]PressDate:64)

ARRAY DATE:C224($pressDate; 0)
$numFGs:=Records in selection:C76([To_Do_Tasks:100])
ARRAY DATE:C224($pressDate; $numFGs)
For ($i; 1; $numFGs)
	$pressDate{$i}:=[Job_Forms_Master_Schedule:67]PressDate:25
End for 
ARRAY TO SELECTION:C261($pressDate; [To_Do_Tasks:100]DateDue:10)

[Job_Forms_Master_Schedule:67]WeekNumber:38:=util_weekNumber([Job_Forms_Master_Schedule:67]PressDate:25)

C_BOOLEAN:C305($setDate)
$setDate:=False:C215
If ($setDate)
	If (Records in selection:C76([To_Do_Tasks:100])>0)
		QUERY SELECTION:C341([To_Do_Tasks:100]; [To_Do_Tasks:100]Done:4=False:C215)
		If (Records in selection:C76([To_Do_Tasks:100])=0)
			$setDate:=True:C214
		End if 
	End if 
	If ($setDate)
		If ([Job_Forms_Master_Schedule:67]DateFinalToolApproved:18=!00-00-00!)
			[Job_Forms_Master_Schedule:67]DateFinalToolApproved:18:=4D_Current_date
		End if 
		If ([Job_Forms_Master_Schedule:67]DateClosingMet:23=!00-00-00!)
			[Job_Forms_Master_Schedule:67]DateClosingMet:23:=JML_getGateWayMet([Job_Forms_Master_Schedule:67]JobForm:4)
		End if 
	End if 
End if 

If ([Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!)
	// Removed by: MelvinBohince (3/28/22) 
	//$i:=RM_AllocationSchedule ([Job_Forms_Master_Schedule]JobForm;([Job_Forms_Master_Schedule]PressDate-1))
	
	If ([Job_Forms_Master_Schedule:67]GateWayDeadLine:42=!00-00-00!) & (False:C215)  // • mel (11/9/04, 15:52:35)disabled
		[Job_Forms_Master_Schedule:67]GateWayDeadLine:42:=[Job_Forms_Master_Schedule:67]PressDate:25-(7*2)
	End if 
	
	If ([Job_Forms_Master_Schedule:67]DD_FinalOks:24=!00-00-00!)
		[Job_Forms_Master_Schedule:67]DD_FinalOks:24:=[Job_Forms_Master_Schedule:67]PressDate:25-5
	End if 
End if 

If (Old:C35([Job_Forms_Master_Schedule:67]PlannerReleased:14)=!00-00-00!)
	If ([Job_Forms_Master_Schedule:67]PlannerReleased:14#!00-00-00!)
		Job_StatusReleaseJobBag([Job_Forms_Master_Schedule:67]JobForm:4)
	End if 
End if 

If (Old:C35([Job_Forms_Master_Schedule:67]DateStockRecd:17)=!00-00-00!)
	If ([Job_Forms_Master_Schedule:67]DateStockRecd:17#!00-00-00!)
		READ WRITE:C146([Job_Forms:42])
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Job_Forms_Master_Schedule:67]JobForm:4)
		If (Records in selection:C76([Job_Forms:42])=1)
			[Job_Forms:42]StockRecd:17:=[Job_Forms_Master_Schedule:67]DateStockRecd:17
			SAVE RECORD:C53([Job_Forms:42])
			UNLOAD RECORD:C212([Job_Forms:42])
		End if 
	End if 
End if 

If (Old:C35([Job_Forms_Master_Schedule:67]PressDate:25)#!00-00-00!)
	If (Old:C35([Job_Forms_Master_Schedule:67]PressDate:25)#[Job_Forms_Master_Schedule:67]PressDate:25)
		[Job_Forms_Master_Schedule:67]PressChgCount:44:=[Job_Forms_Master_Schedule:67]PressChgCount:44+1
		[Job_Forms_Master_Schedule:67]PressChgLog:45:=String:C10(Old:C35([Job_Forms_Master_Schedule:67]PressDate:25); Internal date short special:K1:4)+<>zResp+Char:C90(13)+[Job_Forms_Master_Schedule:67]PressChgLog:45
		[Job_Forms_Master_Schedule:67]Comment:22:=Request:C163("Why did you change the Press date?"; "sht hppns"; "OK"; "No really")+" "+String:C10(4D_Current_date)+"; "+[Job_Forms_Master_Schedule:67]Comment:22
		If (OK=0)
			[Job_Forms_Master_Schedule:67]Comment:22:=<>zResp+" chg'd the press date without comment on "+String:C10(4D_Current_date)+"; "+[Job_Forms_Master_Schedule:67]Comment:22
		End if 
	End if 
End if 

If (Old:C35([Job_Forms_Master_Schedule:67]DateComplete:15)=!00-00-00!)
	If ([Job_Forms_Master_Schedule:67]DateComplete:15#!00-00-00!)
		JML_setJobComplete([Job_Forms_Master_Schedule:67]JobForm:4)
	End if 
End if 

If (Old:C35([Job_Forms_Master_Schedule:67]MAD:21)#[Job_Forms_Master_Schedule:67]MAD:21)  // | (Old([JobMasterLog]OrigRevDate)#[JobMasterLog]OrigRevDate)
	JML_EmailChgMAD
	[Job_Forms_Master_Schedule:67]OrigRevDate:20:=Old:C35([Job_Forms_Master_Schedule:67]MAD:21)
	If (Old:C35([Job_Forms_Master_Schedule:67]MAD:21)#!00-00-00!)
		[Job_Forms_Master_Schedule:67]Comment:22:="HRD was "+String:C10([Job_Forms_Master_Schedule:67]OrigRevDate:20; System date short:K1:1)+" changed on "+String:C10(4D_Current_date; System date short:K1:1)+Char:C90(13)+[Job_Forms_Master_Schedule:67]Comment:22
	End if 
	READ WRITE:C146([Job_Forms_Items:44])  // • mel (8/6/04, 16:09:33)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		qryJMI([Job_Forms_Master_Schedule:67]JobForm:4; 0; "@")
		
		QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]MAD:37<[Job_Forms_Master_Schedule:67]MAD:21)
		
	Else 
		
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=[Job_Forms_Master_Schedule:67]JobForm:4; *)
		QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]ProductCode:3="@"; *)
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]MAD:37<[Job_Forms_Master_Schedule:67]MAD:21)
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]MAD:37:=[Job_Forms_Master_Schedule:67]MAD:21)
	//End if 
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
End if 

READ WRITE:C146([ProductionSchedules:110])
QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=([Job_Forms_Master_Schedule:67]JobForm:4+"@"))

START TRANSACTION:C239
APPLY TO SELECTION:C70([ProductionSchedules:110]; PS_setJobInfo([ProductionSchedules:110]JobSequence:8))
$numLocked:=Records in set:C195("LockedSet")
If ($numLocked=0)
	VALIDATE TRANSACTION:C240
Else 
	CANCEL TRANSACTION:C241
	If ($numLocked=1)
		ALERT:C41(String:C10($numLocked)+" ProductionSchedule record was locked and couldn't be updated.")
		
	Else 
		ALERT:C41(String:C10($numLocked)+" ProductionSchedule records were locked and couldn't be updated.")
	End if 
End if 

//$pf_hrd_date:=PF_util_FormatDate (->[Job_Forms_Master_Schedule]MAD)  // Modified by: Mel Bohince (3/18/18) 
//PF_UpdateJobProperty ([Job_Forms_Master_Schedule]JobForm;"HRD";$pf_hrd_date)
//PF_UpdateJobProperty ([Job_Forms_Master_Schedule]JobForm;"job-HRD";$pf_hrd_date)  //PF_BooleanToYesNo ([Job_Forms_Master_Schedule]MAD#!00/00/0000!)
//PF_UpdateJobProperty ([Job_Forms_Master_Schedule]JobForm;"Stock Received";PF_BooleanToYesNo ([Job_Forms_Master_Schedule]DateStockRecd#!00/00/0000!))  // Modified by: Mel Bohince (3/6/18) 

PF_UpdateJobProperty([Job_Forms_Master_Schedule:67]JobForm:4; True:C214)

REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
REDUCE SELECTION:C351([Finished_Goods:26]; 0)
REDUCE SELECTION:C351([Job_Forms:42]; 0)
REDUCE SELECTION:C351([Jobs:15]; 0)
REDUCE SELECTION:C351([Customers:16]; 0)
REDUCE SELECTION:C351([To_Do_Tasks:100]; 0)
<>jobform:=""
//%attributes = {"publishedWeb":true}
//PM: PS_LoadJobSeq() -> 
//@author Mel Bohince - 12/4/01  14:09

C_LONGINT:C283($lastPriority; $numJML; $i)
// Modified by: Mel Bohince (1/7/20) this button is now hidden cause they don't want to accidentally click it
uConfirm("Continuing will pull every unscheduled job into schedule."; "Nope"; "Continue")  //just in case they find a way to evoke this
If (ok=0)
	
	If (Records in selection:C76([ProductionSchedules:110])>0)
		LAST RECORD:C200([ProductionSchedules:110])
		$lastPriority:=[ProductionSchedules:110]Priority:3+100
	Else 
		$lastPriority:=100
	End if 
	
	$lastPriority:=Num:C11(Request:C163("Enter starting priority for added sequences: "; String:C10($lastPriority); "Load"; "Abort"))
	If (ok=1)
		Case of 
			: (Position:C15(sCriterion1; <>PRESSES)>0)
				QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
				QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!)
			: (Position:C15(sCriterion1; <>SHEETERS)>0)
				QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
				QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateStockSheeted:47=!00-00-00!; *)
				QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!; *)
				QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateStockRecd:17#!00-00-00!)
			: (Position:C15(sCriterion1; <>STAMPERS)>0)
				QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
				QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]GlueReady:28=!00-00-00!; *)
				QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!; *)
				QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32#!00-00-00!)
			: (Position:C15(sCriterion1; <>BLANKERS)>0)
				QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
				QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]GlueReady:28=!00-00-00!; *)
				QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!; *)
				QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32#!00-00-00!)
		End case 
		//QUERY([JobMasterLog]; & ;[JobMasterLog]MAD#!00/00/00!)
		$numJML:=Records in selection:C76([Job_Forms_Master_Schedule:67])
		ORDER BY:C49([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]MAD:21; >)
		$count:=0
		uThermoInit($numJML; "Looking for new job sequences")
		For ($i; 1; $numJML)
			uThermoUpdate($i; 1)
			Case of 
				: ([Job_Forms_Master_Schedule:67]LocationOfMfg:30="VA")
					$finshAt:="VA"
					//: (position("OS";[Job_Forms_Master_Schedule]LocationOfMfg)>0)
					//$finshAt:="OS"
					
				Else 
					$finshAt:="VA"
			End case 
			
			Case of 
				: (Position:C15(sCriterion1; <>PRESSES)>0)
					QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]CostCenterID:4="418"; *)
					QUERY:C277([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4="413"; *)
					QUERY:C277([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4="419"; *)
					//QUERY([Job_Forms_Machines]; | ;[Job_Forms_Machines]CostCenterID="416";*)
					QUERY:C277([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4="417"; *)
					QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]ActualEnd:31=!00-00-00!; *)
					QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]JobForm:1=[Job_Forms_Master_Schedule:67]JobForm:4)
				: (Position:C15(sCriterion1; <>SHEETERS)>0)
					QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]CostCenterID:4="429"; *)
					QUERY:C277([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4="428"; *)
					QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]ActualEnd:31=!00-00-00!; *)
					QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]JobForm:1=[Job_Forms_Master_Schedule:67]JobForm:4)
				: (Position:C15(sCriterion1; <>STAMPERS)>0)
					QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]CostCenterID:4="451"; *)
					QUERY:C277([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4="452"; *)
					QUERY:C277([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4="453"; *)
					QUERY:C277([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4="454"; *)
					QUERY:C277([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4="461"; *)
					QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]ActualEnd:31=!00-00-00!; *)
					QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]JobForm:1=[Job_Forms_Master_Schedule:67]JobForm:4)
				: (Position:C15(sCriterion1; <>BLANKERS)>0)
					QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]CostCenterID:4="468"; *)
					QUERY:C277([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4="469"; *)
					QUERY:C277([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4="462"; *)
					QUERY:C277([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4="463"; *)
					QUERY:C277([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4="492"; *)
					QUERY:C277([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4="462"; *)
					QUERY:C277([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4="491"; *)
					QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]ActualEnd:31=!00-00-00!; *)
					QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]JobForm:1=[Job_Forms_Master_Schedule:67]JobForm:4)
			End case 
			ORDER BY:C49([Job_Forms_Machines:43]; [Job_Forms_Machines:43]Sequence:5; >)
			For ($j; 1; Records in selection:C76([Job_Forms_Machines:43]))
				$jobSeq:=[Job_Forms_Machines:43]JobForm:1+"."+String:C10([Job_Forms_Machines:43]Sequence:5; "000")
				QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=$jobSeq)
				If (Records in selection:C76([ProductionSchedules:110])=0)  //not already there
					$count:=$count+1
					CREATE RECORD:C68([ProductionSchedules:110])
					[ProductionSchedules:110]JobSequence:8:=$jobSeq
					[ProductionSchedules:110]Line:10:=[Job_Forms_Master_Schedule:67]Line:5
					[ProductionSchedules:110]Customer:11:=[Job_Forms_Master_Schedule:67]Customer:2
					[ProductionSchedules:110]CostCenter:1:=[Job_Forms_Machines:43]CostCenterID:4
					If ([ProductionSchedules:110]CostCenter:1="451")
						If ($finshAt="VA")
							[ProductionSchedules:110]CostCenter:1:="452"
						Else 
							[ProductionSchedules:110]CostCenter:1:="453"
						End if 
					End if 
					
					If ([ProductionSchedules:110]CostCenter:1="463")
						If ($finshAt="VA")
							[ProductionSchedules:110]CostCenter:1:="468"
						Else 
							[ProductionSchedules:110]CostCenter:1:="461"
						End if 
					End if 
					
					QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=[ProductionSchedules:110]CostCenter:1)
					[ProductionSchedules:110]Name:2:=[Cost_Centers:27]Description:3
					[ProductionSchedules:110]Priority:3:=$lastPriority
					$lastPriority:=$lastPriority+10
					
					[ProductionSchedules:110]StartDate:4:=[Job_Forms_Master_Schedule:67]PressDate:25
					[ProductionSchedules:110]StartTime:5:=?00:00:00?
					$hrs:=0
					If ([Job_Forms_Machines:43]Planned_RunHrs:37>0)
						$hrs:=$hrs+[Job_Forms_Machines:43]Planned_RunHrs:37
					End if 
					If ([Job_Forms_Machines:43]Planned_MR_Hrs:15>0)
						$hrs:=$hrs+[Job_Forms_Machines:43]Planned_MR_Hrs:15
					End if 
					
					[ProductionSchedules:110]Planned_MR:52:=[Job_Forms_Machines:43]Planned_MR_Hrs:15
					[ProductionSchedules:110]Planned_Run:53:=[Job_Forms_Machines:43]Planned_RunHrs:37
					[ProductionSchedules:110]Planned_RunRate:54:=[Job_Forms_Machines:43]Planned_RunRate:36
					[ProductionSchedules:110]Planned_QtyGood:56:=[Job_Forms_Machines:43]Planned_Qty:10
					[ProductionSchedules:110]Planned_QtyWaste:55:=[Job_Forms_Machines:43]Planned_Waste:11
					
					[ProductionSchedules:110]DurationSeconds:9:=Time:C179(Time string:C180(($hrs*3600)))
					$start:=TSTimeStamp([ProductionSchedules:110]StartDate:4; [ProductionSchedules:110]StartTime:5)
					$duration:=[ProductionSchedules:110]DurationSeconds:9*1
					$end:=$start+$duration
					TS2DateTime($end; ->[ProductionSchedules:110]EndDate:6; ->[ProductionSchedules:110]EndTime:7)
					[ProductionSchedules:110]Info:13:=String:C10(Round:C94([Job_Forms_Machines:43]Planned_MR_Hrs:15; 0))+"+"+String:C10(Round:C94([Job_Forms_Machines:43]Planned_RunHrs:37; 0))  //+" Stk="+[JobMasterLog]S_Number      
					
					$err:=Job_getPrevNextOperation($jobSeq; ->[ProductionSchedules:110]AllOperations:14)
					
					[ProductionSchedules:110]NumSubForms:16:=JMI_getNumSubforms([Job_Forms_Master_Schedule:67]JobForm:4)
					
					SAVE RECORD:C53([ProductionSchedules:110])
				End if 
				NEXT RECORD:C51([Job_Forms_Machines:43])
			End for 
			NEXT RECORD:C51([Job_Forms_Master_Schedule:67])
		End for 
		uThermoClose
		
		pressBackLog:=PS_qryCurrentBackLog(sCriterion1)
		BEEP:C151
		zwStatusMsg("LOAD"; String:C10($count)+" job sequences have been appended to the schedule.")
		FIRST RECORD:C50([ProductionSchedules:110])
		//Else 
		//BEEP
		//ALERT("Press not specified")
		//End if 
	Else 
		BEEP:C151
		zwStatusMsg("LOAD"; "Aborted")
	End if   //requst
	
End if 
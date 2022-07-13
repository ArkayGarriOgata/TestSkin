//OM: bOk() -> 
//@author mlb - 3/22/02  14:23
If (Length:C16(sCriterion9)=12) & (sCriterion9#"00000.00.000") & (Records in selection:C76([Job_Forms_Machines:43])>0)
	If (sAction="New")
		CREATE RECORD:C68([ProductionSchedules:110])
	End if 
	
	[ProductionSchedules:110]JobSequence:8:=sCriterion9
	[ProductionSchedules:110]CostCenter:1:=sCriterion1
	If ((Position:C15([ProductionSchedules:110]CostCenter:1; <>EMBOSSERS)>0) | (Position:C15([ProductionSchedules:110]CostCenter:1; <>STAMPERS)>0))
		[ProductionSchedules:110]Name:2:=CostCtr_Description_Tweak(->[Job_Forms_Machines:43]Flex_field1:6)
	Else 
		[ProductionSchedules:110]Name:2:=[Cost_Centers:27]Description:3
	End if 
	
	[ProductionSchedules:110]Line:10:=sCriterion3
	[ProductionSchedules:110]Customer:11:=sCriterion2
	
	If (rb1=1)
		[ProductionSchedules:110]FixedStart:12:=True:C214
		[ProductionSchedules:110]Priority:3:=Num:C11(sCriterion5)
		[ProductionSchedules:110]StartDate:4:=dDate
		[ProductionSchedules:110]StartTime:5:=tTime
	Else 
		[ProductionSchedules:110]FixedStart:12:=False:C215
		[ProductionSchedules:110]Priority:3:=Num:C11(sCriterion5)
		[ProductionSchedules:110]StartDate:4:=dDate
		[ProductionSchedules:110]StartTime:5:=tTime
	End if 
	
	[ProductionSchedules:110]Planned_MR:52:=[Job_Forms_Machines:43]Planned_MR_Hrs:15
	[ProductionSchedules:110]Planned_Run:53:=[Job_Forms_Machines:43]Planned_RunHrs:37
	[ProductionSchedules:110]Info:13:=String:C10(Round:C94([Job_Forms_Machines:43]Planned_MR_Hrs:15; 0))+"+"+String:C10(Round:C94([Job_Forms_Machines:43]Planned_RunHrs:37; 0))  //+" Stk="+[JobMasterLog]S_Number      
	
	[ProductionSchedules:110]Planned_RunRate:54:=[Job_Forms_Machines:43]Planned_RunRate:36
	[ProductionSchedules:110]Planned_QtyGood:56:=[Job_Forms_Machines:43]Planned_Qty:10
	[ProductionSchedules:110]Planned_QtyWaste:55:=[Job_Forms_Machines:43]Planned_Waste:11
	
	[ProductionSchedules:110]DurationSeconds:9:=Time:C179(sCriterion4)
	$newDuration:=[ProductionSchedules:110]DurationSeconds:9
	$start:=TSTimeStamp([ProductionSchedules:110]StartDate:4; [ProductionSchedules:110]StartTime:5)
	$duration:=[ProductionSchedules:110]DurationSeconds:9*1
	$end:=$start+$duration
	TS2DateTime($end; ->[ProductionSchedules:110]EndDate:6; ->[ProductionSchedules:110]EndTime:7)
	
	$err:=Job_getPrevNextOperation(sCriterion9; ->[ProductionSchedules:110]AllOperations:14)
	
	[ProductionSchedules:110]NumSubForms:16:=JMI_getNumSubforms(Substring:C12(sCriterion9; 1; 8))
	
	PS_setJobInfo(sCriterion9)
	
	SAVE RECORD:C53([ProductionSchedules:110])
	zwStatusMsg("NEW"; sCriterion9+" has been added for "+sCriterion3)
	
	If (Num:C11(sCriterion6)>0)  //consume a Block
		QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]Priority:3=sCriterion6)
		//QUERY([ProductionSchedule];[ProductionSchedule]JobSequence="Blocked")
		If (Records in selection:C76([ProductionSchedules:110])>0)
			[ProductionSchedules:110]DurationSeconds:9:=[ProductionSchedules:110]DurationSeconds:9-$newDuration
			
			$start:=TSTimeStamp([ProductionSchedules:110]StartDate:4; [ProductionSchedules:110]StartTime:5)
			$duration:=[ProductionSchedules:110]DurationSeconds:9*1
			$end:=$start+$duration
			TS2DateTime($end; ->[ProductionSchedules:110]EndDate:6; ->[ProductionSchedules:110]EndTime:7)
			SAVE RECORD:C53([ProductionSchedules:110])
			If ([ProductionSchedules:110]DurationSeconds:9<=?00:00:00?)
				DELETE RECORD:C58([ProductionSchedules:110])
			End if 
			
		Else 
			BEEP:C151
			ALERT:C41("Couldn't consume Block at priority "+sCriterion6)
		End if 
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("Enter a Job Sequence")
End if 
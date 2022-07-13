//%attributes = {"publishedWeb":true}
//PM: PS_ExtendSheeting() -> 
//@author mlb - 6/5/02  13:42

CONFIRM:C162("Reset Sheeting Start Date & Time to so it finishes before first press date?")
If (OK=1)
	C_LONGINT:C283($i; $numPS)
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
		
		PS_qrySheetingOnly
		CREATE SET:C116([ProductionSchedules:110]; "SheetingRecs")
		
	Else 
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "SheetingRecs")
		PS_qrySheetingOnly
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	PS_qryPrintingOnly
	SELECTION TO ARRAY:C260([ProductionSchedules:110]JobSequence:8; $aJob; [ProductionSchedules:110]StartDate:4; $aStartDate; [ProductionSchedules:110]StartTime:5; $aStartTime)
	REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
	
	$numPS:=Size of array:C274($aJob)
	If ($numPS>0)
		ARRAY LONGINT:C221($aBegin; $numPS)
		ARRAY TEXT:C222($aSortKey; $numPS)
		For ($i; 1; $numPS)
			$aJob{$i}:=Substring:C12($aJob{$i}; 1; 8)
			$aBegin{$i}:=TSTimeStamp(($aStartDate{$i}); $aStartTime{$i})
			$aSortKey{$i}:=$aJob{$i}+String:C10($aBegin{$i})
		End for 
		
		SORT ARRAY:C229($aSortKey; $aBegin; $aJob; >)
		ARRAY DATE:C224($aStartDate; 0)
		ARRAY LONGINT:C221($aStartTime; 0)
		ARRAY TEXT:C222($aSortKey; 0)
		
		START TRANSACTION:C239
		$lastJobForm:=""
		uThermoInit($numPS; "Extending Sheeting Schedule")
		For ($i; 1; $numPS)
			uThermoUpdate($i)
			If ($aJob{$i}#$lastJobForm)
				$lastJobForm:=$aJob{$i}
				
				USE SET:C118("SheetingRecs")
				// ******* Verified  - 4D PS - January  2019 ********
				
				QUERY SELECTION:C341([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=($aJob{$i}+"@"))
				
				// ******* Verified  - 4D PS - January 2019 (end) *********
				
				If (Records in selection:C76([ProductionSchedules:110])>0)
					If (fLockNLoad(->[ProductionSchedules:110]))
						$duration:=([ProductionSchedules:110]DurationSeconds:9*1)
						$start:=$aBegin{$i}-$duration
						TS2DateTime($start; ->[ProductionSchedules:110]StartDate:4; ->[ProductionSchedules:110]StartTime:5)
						$end:=$start+$duration
						TS2DateTime($end; ->[ProductionSchedules:110]EndDate:6; ->[ProductionSchedules:110]EndTime:7)
						[ProductionSchedules:110]Comment:22:="/"+[ProductionSchedules:110]Comment:22
						SAVE RECORD:C53([ProductionSchedules:110])
					Else   //locked
						$i:=1+$numPS  //break
					End if 
					
				Else   //get the sheeting sequence
					QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]CostCenterID:4="429"; *)
					QUERY:C277([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4="428"; *)
					QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]ActualEnd:31=!00-00-00!; *)
					QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]JobForm:1=$aJob{$i})
					If (Records in selection:C76([Job_Forms_Machines:43])>0)
						QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$aJob{$i})
						If ([Job_Forms_Master_Schedule:67]DateStockSheeted:47=!00-00-00!)
							CREATE RECORD:C68([ProductionSchedules:110])
							[ProductionSchedules:110]JobSequence:8:=[Job_Forms_Machines:43]JobForm:1+"."+String:C10([Job_Forms_Machines:43]Sequence:5; "000")
							[ProductionSchedules:110]Line:10:=[Job_Forms_Master_Schedule:67]Line:5
							[ProductionSchedules:110]Customer:11:=[Job_Forms_Master_Schedule:67]Customer:2
							[ProductionSchedules:110]CostCenter:1:=[Job_Forms_Machines:43]CostCenterID:4
							QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=[ProductionSchedules:110]CostCenter:1)
							[ProductionSchedules:110]Name:2:=[Cost_Centers:27]Description:3
							If ([ProductionSchedules:110]CostCenter:1="427")
								[ProductionSchedules:110]CostCenter:1:="429"
							End if 
							
							[ProductionSchedules:110]Priority:3:=0
							
							$hrs:=0
							If ([Job_Forms_Machines:43]Planned_RunHrs:37>0)
								$hrs:=$hrs+[Job_Forms_Machines:43]Planned_RunHrs:37
							End if 
							If ([Job_Forms_Machines:43]Planned_MR_Hrs:15>0)
								$hrs:=$hrs+[Job_Forms_Machines:43]Planned_MR_Hrs:15
							End if 
							
							[ProductionSchedules:110]DurationSeconds:9:=Time:C179(Time string:C180(($hrs*3600)))
							$duration:=[ProductionSchedules:110]DurationSeconds:9*1
							$start:=$aBegin{$i}-$duration
							TS2DateTime($start; ->[ProductionSchedules:110]StartDate:4; ->[ProductionSchedules:110]StartTime:5)
							
							$end:=$start+$duration
							TS2DateTime($end; ->[ProductionSchedules:110]EndDate:6; ->[ProductionSchedules:110]EndTime:7)
							[ProductionSchedules:110]Info:13:=String:C10(Round:C94([Job_Forms_Machines:43]Planned_MR_Hrs:15; 0))+"+"+String:C10(Round:C94([Job_Forms_Machines:43]Planned_RunHrs:37; 0))  //+" Stk="+[JobMasterLog]S_Number      
							
							$err:=Job_getPrevNextOperation($jobSeq; ->[ProductionSchedules:110]AllOperations:14)
							
							[ProductionSchedules:110]NumSubForms:16:=JMI_getNumSubforms([Job_Forms_Master_Schedule:67]JobForm:4)
							[ProductionSchedules:110]Comment:22:="+"
							SAVE RECORD:C53([ProductionSchedules:110])
						End if   //not sheeted
					End if   //machJob record exists
				End if   //record exists
			End if   //not same form
		End for   //each press records
		uThermoClose
		
		If (<>fContinue)
			VALIDATE TRANSACTION:C240
		Else   //locked record encountered
			CANCEL TRANSACTION:C241
			BEEP:C151
			ALERT:C41("A Locked record prevented the Schedule from being Extended")
		End if 
		
	Else   //no press records
		BEEP:C151
	End if 
	
	CLEAR SET:C117("SheetingRecs")
	
	QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=sCriterion1)
	If (Records in selection:C76([ProductionSchedules:110])>0)
		pressBackLog:=Sum:C1([ProductionSchedules:110]DurationSeconds:9)/3600
		ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]StartDate:4; >)
	Else 
		pressBackLog:=0
	End if 
	BEEP:C151
	//zwStatusMsg ("LOAD";String($count)+" job sequences have been appended to the 
	//«schedule.")
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		FIRST RECORD:C50([ProductionSchedules:110])
		
	Else 
		
		// you don' t need it
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	
End if 
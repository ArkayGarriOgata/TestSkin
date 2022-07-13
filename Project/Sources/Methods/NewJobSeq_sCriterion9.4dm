//%attributes = {}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: NewJobSeq_sCriterion9 - Created `v1.0.0-PJK (12/16/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 


//READ ONLY([Job_Forms_Machines])


REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)

Case of 
	: (Length:C16(sCriterion9)=9)  //estimate number entered
		sCriterion9:=PS_getJobSeqFromEstimate(sCriterion9)
	: (Length:C16(sCriterion9)=5)
		sCriterion9:=PS_pickSequence(Num:C11(sCriterion9))
End case 

sAction:="New"

QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=sCriterion9)
QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobSequence:8=sCriterion9)  //v1.0.0-PJK (12/17/15) moved outside
If (Records in selection:C76([ProductionSchedules:110])=0)
	//v1.0.0-PJK (12/17/15) move outside QUERY([Job_Forms_Machines];[Job_Forms_Machines]JobSequence=sCriterion9)
	If (Records in selection:C76([Job_Forms_Machines:43])>0)
		RELATE ONE:C42([Job_Forms_Machines:43]JobForm:1)
		RELATE ONE:C42([Job_Forms:42]JobNo:2)
		sCriterion2:=[Jobs:15]CustomerName:5
		sCriterion3:=[Jobs:15]Line:3
		$hrs:=0
		rStd_MR:=[Job_Forms_Machines:43]Planned_MR_Hrs:15
		rStd_Run:=[Job_Forms_Machines:43]Planned_RunHrs:37
		If (rStd_Run>0)
			$hrs:=$hrs+rStd_Run
		End if 
		If (rStd_MR>0)
			$hrs:=$hrs+rStd_MR
		End if 
		
		$tHrs:=Time:C179(Time string:C180(($hrs*3600)))
		sCriterion4:=String:C10($tHrs; HH MM:K7:2)
		
	Else 
		BEEP:C151
		ALERT:C41(sCriterion9+" not found on budget")
		sCriterion9:="00000.00.000"
		GOTO OBJECT:C206(sCriterion9)
		If (fFromAdvScheduler)  //v1.0.0-PJK (12/17/15) if we are using the advanced scheule, CANCEL out now
			CANCEL:C270
		End if 
	End if 
	
Else   //exsists
	BEEP:C151
	If ([ProductionSchedules:110]CostCenter:1#sCriterion1)
		CONFIRM:C162(sCriterion9+" is already scheduled on the "+[ProductionSchedules:110]Name:2; "Move to "+sCriterion1; "Cancel")
		If (ok=0)
			sCriterion9:="00000.00.000"
			GOTO OBJECT:C206(sCriterion9)
			If (fFromAdvScheduler)  //v1.0.0-PJK (12/17/15) if we are using the advanced scheule, CANCEL out now
				CANCEL:C270
			End if 
		Else 
			sAction:="Move"
			SetObjectProperties(""; ->bOK; True:C214; "Move")
			sCriterion2:=[ProductionSchedules:110]Customer:11
			sCriterion3:=[ProductionSchedules:110]Line:10
			sCriterion4:=String:C10([ProductionSchedules:110]DurationSeconds:9; HH MM:K7:2)
		End if 
		
	Else 
		ALERT:C41(sCriterion9+" is already scheduled on this press at priority "+String:C10([ProductionSchedules:110]Priority:3))
		sCriterion9:="00000.00.000"
		GOTO OBJECT:C206(sCriterion9)
		If (fFromAdvScheduler)  //v1.0.0-PJK (12/17/15) if we are using the advanced scheule, CANCEL out now
			CANCEL:C270
		End if 
	End if 
End if 
//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/01/07, 13:14:30
// ----------------------------------------------------
// Method: trigger_JobFormMachines()  --> 
// ----------------------------------------------------

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[Job_Forms_Machines:43]JobSequence:8:=[Job_Forms_Machines:43]JobForm:1+"."+String:C10([Job_Forms_Machines:43]Sequence:5; "000")
		[Job_Forms_Machines:43]Actual_RunRate:39:=NaNtoZero([Job_Forms_Machines:43]Actual_RunRate:39)
		[Job_Forms_Machines:43]CostCenterID:4:=CostCenterObsoleteSubstitutions([Job_Forms_Machines:43]CostCenterID:4)
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[Job_Forms_Machines:43]Actual_RunRate:39:=NaNtoZero([Job_Forms_Machines:43]Actual_RunRate:39)
		[Job_Forms_Machines:43]CostCenterID:4:=CostCenterObsoleteSubstitutions([Job_Forms_Machines:43]CostCenterID:4)
End case 
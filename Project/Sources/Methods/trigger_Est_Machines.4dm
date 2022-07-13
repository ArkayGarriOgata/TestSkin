//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 10/16/07, 18:09:39
// ----------------------------------------------------
// Method: trigger_Est_Machines
// ----------------------------------------------------

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[Estimates_Machines:20]RunningHrs:32:=NaNtoZero([Estimates_Machines:20]RunningHrs:32)
		[Estimates_Machines:20]CostCtrID:4:=CostCenterObsoleteSubstitutions([Estimates_Machines:20]CostCtrID:4)
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[Estimates_Machines:20]RunningHrs:32:=NaNtoZero([Estimates_Machines:20]RunningHrs:32)
		[Estimates_Machines:20]CostCtrID:4:=CostCenterObsoleteSubstitutions([Estimates_Machines:20]CostCtrID:4)
End case 
//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 11/24/15, 15:20:04
// ----------------------------------------------------
// Method: trigger_ProcessSpecMachines
// Description
// 
//
// ----------------------------------------------------


Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[Process_Specs_Machines:28]CostCenterID:4:=CostCenterObsoleteSubstitutions([Process_Specs_Machines:28]CostCenterID:4)
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[Process_Specs_Machines:28]CostCenterID:4:=CostCenterObsoleteSubstitutions([Process_Specs_Machines:28]CostCenterID:4)
End case 
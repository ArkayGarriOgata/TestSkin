//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/01/07, 13:43:50
// ----------------------------------------------------
// Method: trigger_JPSItems()  --> 
// ----------------------------------------------------

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[JPSI_Job_Physical_Support_Items:111]SortDescript:9:=Substring:C12([JPSI_Job_Physical_Support_Items:111]Description:4; 1; 79)
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[JPSI_Job_Physical_Support_Items:111]SortDescript:9:=Substring:C12([JPSI_Job_Physical_Support_Items:111]Description:4; 1; 79)
End case 
//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/01/07, 13:41:35
// ----------------------------------------------------
// Method: trigger_QASection()  --> 
// ----------------------------------------------------

Case of 
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[QA_Section:109]LastUpdate:6:=4D_Current_date
		
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[QA_Section:109]LastUpdate:6:=4D_Current_date
End case 
//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/01/07, 13:40:44
// ----------------------------------------------------
// Method: trigger_QAProcedures()  --> 
// ----------------------------------------------------

Case of 
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[QA_Procedures:108]LastUpdate:5:=4D_Current_date
		
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[QA_Procedures:108]LastUpdate:5:=4D_Current_date
End case 
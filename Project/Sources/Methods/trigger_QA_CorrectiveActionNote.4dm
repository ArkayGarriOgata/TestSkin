//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/01/07, 13:49:24
// ----------------------------------------------------
// Method: trigger_QA_CorrectiveActionNote()  --> 
// ----------------------------------------------------

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[QA_Corrective_Actions_Notes:143]DateCreated:2:=Current date:C33
		[QA_Corrective_Actions_Notes:143]TimeCreated:3:=Current time:C178
End case 
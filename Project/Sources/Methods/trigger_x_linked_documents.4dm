//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/01/07, 13:47:39
// ----------------------------------------------------
// Method: trigger_x_linked_documents()  --> 
// ----------------------------------------------------

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[x_linked_documents:133]linkID:2:=app_GetPrimaryKey  //String(app_AutoIncrement (->[x_linked_documents]);"0000000000")
End case 
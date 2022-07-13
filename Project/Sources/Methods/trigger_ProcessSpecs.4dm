//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/01/07, 11:51:26
// ----------------------------------------------------
// Method: trigger_ProcessSpecs()  --> 
// ----------------------------------------------------

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[Process_Specs:18]PSpecKey:106:=[Process_Specs:18]Cust_ID:4+":"+[Process_Specs:18]ID:1
		[Process_Specs:18]LastUsed:5:=4D_Current_date
		$0:=0
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)  //• mlb - 12/11/02  16:49
		[Process_Specs:18]PSpecKey:106:=[Process_Specs:18]Cust_ID:4+":"+[Process_Specs:18]ID:1
		[Process_Specs:18]LastUsed:5:=4D_Current_date
		$0:=0
		
End case 
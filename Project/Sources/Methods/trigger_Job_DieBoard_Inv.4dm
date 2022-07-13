//%attributes = {}
// _______
// Method: trigger_Job_DieBoard_Inv   ( ) ->
// By: Mel Bohince @ 05/21/19, 11:24:19
// Description
// post location bin to Job_DieBoard table
// ----------------------------------------------------

C_LONGINT:C283($0)

$0:=0  //assume granted

Case of 
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[Job_DieBoard_Inv:168]Location:8:=[Job_DieBoard_Inv:168]CatelogID:10
		
		
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[Job_DieBoard_Inv:168]Location:8:=[Job_DieBoard_Inv:168]CatelogID:10
		
End case 
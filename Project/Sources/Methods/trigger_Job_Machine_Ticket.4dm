//%attributes = {}

// Method: trigger_Job_Machine_Ticket ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/04/14, 11:47:17
// ----------------------------------------------------
// Description
// make a jobit from entry
//
// ----------------------------------------------------

C_LONGINT:C283($0)

$0:=0  //assume granted

Case of 
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[Job_Forms_Machine_Tickets:61]Jobit:23:=JMI_makeJobIt([Job_Forms_Machine_Tickets:61]JobForm:1; [Job_Forms_Machine_Tickets:61]GlueMachItemNo:4)
		[Job_Forms_Machine_Tickets:61]JobFormSeq:16:=[Job_Forms_Machine_Tickets:61]JobForm:1+"."+String:C10([Job_Forms_Machine_Tickets:61]Sequence:3; "000")
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[Job_Forms_Machine_Tickets:61]Jobit:23:=JMI_makeJobIt([Job_Forms_Machine_Tickets:61]JobForm:1; [Job_Forms_Machine_Tickets:61]GlueMachItemNo:4)
		[Job_Forms_Machine_Tickets:61]JobFormSeq:16:=[Job_Forms_Machine_Tickets:61]JobForm:1+"."+String:C10([Job_Forms_Machine_Tickets:61]Sequence:3; "000")
		If ([Job_Forms_Machine_Tickets:61]TimeStampEntered:17=0)
			[Job_Forms_Machine_Tickets:61]TimeStampEntered:17:=TSTimeStamp
		End if 
End case 
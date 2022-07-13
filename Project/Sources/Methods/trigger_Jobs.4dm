//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 08/21/13, 16:41:29
// ----------------------------------------------------
// Method: trigger_Jobs
// Description
// 
//
// Parameters
// ----------------------------------------------------
C_LONGINT:C283($0)

$0:=0  //assume granted

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1) | (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[Jobs:15]CustomerName:5:=CUST_getName([Jobs:15]CustID:2)  // Modified by: Mel Bohince (8/21/13)
End case 
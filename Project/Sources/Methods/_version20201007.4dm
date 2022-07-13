//%attributes = {}
// _______
// Method: _version20201007   ( ) ->
// By: Garri Ogata @ 10/07/20, 15:36:18
// Description
//     Clear out the [x_Usage_Stats] table to get ready to evaluate a distributed database
//        for the last three years the only thing that had been logged where done by User_AllowedCustomer
//        for "Access Violation" that is blocked out now.
// ----------------------------------------------------

If (<>dLASTUPDATE=!2020-10-07!)
	
	READ WRITE:C146([x_Usage_Stats:65])
	ALL RECORDS:C47([x_Usage_Stats:65])
	
	DELETE SELECTION:C66([x_Usage_Stats:65])
	
	READ ONLY:C145([x_Usage_Stats:65])
	
End if 

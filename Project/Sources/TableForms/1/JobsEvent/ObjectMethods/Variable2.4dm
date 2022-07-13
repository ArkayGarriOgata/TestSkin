//(S) [CONTROL]RMEvent'Issue R/M btn

// Modified by: Mel Bohince (6/22/21) orda listboxes dialog added
// Modified by: MelvinBohince (3/28/22) remove older options


//$method:=uYesNoCancel ("Which method of issue?";"Normal";"Experimental";"New")

//Case of 
//: ($method="Normal")  //original
//uSpawnProcess ("RM_Issue";<>lMinMemPart+32000;"Issue:RAW_MATERIALS";True;False)
//If (False)  //list called procedures for 4D Insider
//RM_Issue 
//End if 

//: ($method="Experimental")
//RMX_IssueToJob   //dialog like on eBag

//: ($method="New")  // Modified by: Mel Bohince (6/22/21) orda listboxes.          
RMX_IssueToJob_v2

//End case 



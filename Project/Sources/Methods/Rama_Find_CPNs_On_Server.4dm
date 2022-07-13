//%attributes = {}

// Method: Rama_Find_CPNs_On_Server ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 01/13/15, 11:14:04
// ----------------------------------------------------
// Description
// get a list of items that have been sent to rama or cayey in the past year
//  based on pattern_ExecuteOnServer_Synchro
// ----------------------------------------------------


C_TEXT:C284($msg; $1)

If (Count parameters:C259=0)
	$msg:="client-side"
	
Else 
	$msg:=$1
End if 


Case of 
	: ($msg="client-side")
		// on client side
		server_pid:=0
		C_BOOLEAN:C305(serverMethodDone_local)
		serverMethodDone_local:=False:C215  //reset by server
		
		
		server_pid:=Execute on server:C373("Rama_Find_CPNs_On_Server"; <>lMinMemPart; "RAMA CPN List"; "server-side")
		
		C_TIME:C306($timeOutAt)
		$timeOutAt:=Current time:C178+?00:05:00?
		Repeat   //waiting until server says it ready
			GET PROCESS VARIABLE:C371(server_pid; serverMethodDone; serverMethodDone_local)
			If (Not:C34(serverMethodDone_local))
				zwStatusMsg("SERVER REQUEST"; "Done yet?")
				DELAY PROCESS:C323(Current process:C322; 30)
			End if 
		Until (serverMethodDone_local) | (Current time:C178>$timeOutAt)
		zwStatusMsg("SERVER REQUEST"; "Done!")
		
		
		//load the arrays
		ARRAY TEXT:C222(aCPN; 0)
		If (Current time:C178<$timeOutAt)
			GET PROCESS VARIABLE:C371(server_pid; aCPN; aCPN)
			$0:=True:C214
		Else 
			zwStatusMsg("SERVER REQUEST"; "List of Rama CPN's Timed Out!")
		End if 
		
		// end on client side
		
	: ($msg="server-side")
		// on server side
		C_BOOLEAN:C305(serverMethodDone)
		serverMethodDone:=False:C215
		C_LONGINT:C283(expireAt)
		expireAt:=TSTimeStamp+(60*3)  //time stamp is in seconds so this is 3 minutes
		//do your junk
		ARRAY TEXT:C222(aCPN; 0)
		C_DATE:C307($yearAgo; $today)
		$today:=Current date:C33
		$yearAgo:=Add to date:C393($today; -1; 0; 0)
		
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10="01666"; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  | ; [Customers_ReleaseSchedules:46]Shipto:10="02563"; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5>=$yearAgo)
		
		DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]ProductCode:11; aCPN)
		
		serverMethodDone:=True:C214
		
		While (TSTimeStamp<expireAt)  //wait for the client to get the arrays
			IDLE:C311
			DELAY PROCESS:C323(Current process:C322; (60*10))
		End while 
		// end on server side
End case 

//%attributes = {}

// Method: pattern_ExecuteOnServer_Synchro ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 04/11/14, 16:48:27
// ----------------------------------------------------
// Description
// technique to wait for an Execute on server to finish, 
//   like setting Method Property to run on server
//
// ----------------------------------------------------



// on client side
// on client side
// on client side
server_pid:=0
C_BOOLEAN:C305(serverMethodDone_local)
serverMethodDone_local:=False:C215  //reset by server

server_pid:=Execute on server:C373("JML_Update"; <>lMinMemPart; "Master Log Update")

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

// end on client side

// on server side
// on server side
// on server side
C_BOOLEAN:C305(serverMethodDone)
serverMethodDone:=False:C215
C_LONGINT:C283(expireAt)
expireAt:=TSTimeStamp+(60*3)  //time stamp is in seconds so this is 3 minutes

//do your junk
//do your junk
//do your junk
//do your junk

serverMethodDone:=True:C214

While (TSTimeStamp<expireAt)  //wait for the client to get the arrays
	IDLE:C311
	DELAY PROCESS:C323(Current process:C322; (60*10))
End while 
// end on server side


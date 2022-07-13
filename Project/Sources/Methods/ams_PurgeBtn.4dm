//%attributes = {}

// Method: ams_PurgeBtn ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 06/20/14, 11:26:35
// ----------------------------------------------------
// Description
// based on pattern_StoredProcedure()  -->
// skeleton of a structured, stay-alive stored procedure
// ----------------------------------------------------
// Call procedure without parameters to have it run itself
// ----------------------------------------------------

C_TEXT:C284($1; $2; $3; process_name; process_semaphore)  //$1 is the message, $2 is a tramp used to find an element in the array
C_BOOLEAN:C305($0)
C_LONGINT:C283(server_pid; $hit; $i; $numCPN; $currentExpireAt; expireAt)

If (Count parameters:C259>0)
	$msg:=$1
Else 
	$msg:="do-the-else"
End if 
process_semaphore:="PURGE-SEMEPHORE"
process_name:="PURGE-PROCESS"
$0:=False:C215

Case of 
	: ($msg="client-prep")  //set flags and wait your turn
		//put up a block until server pid has started or its id discovered
		While (Semaphore:C143(process_semaphore))
			DELAY PROCESS:C323(Current process:C322; 10)
		End while 
		
		C_BOOLEAN:C305(serverMethodDone_local)
		serverMethodDone_local:=False:C215  //reset by server
		
		doPurgeChk4Hole
		
	: ($msg="available?")  //decide if it needs started or can use existing
		server_pid:=Process number:C372(process_name; *)
		
		If (server_pid#0)
			//add a minute to expire time to be safe
			GET PROCESS VARIABLE:C371(server_pid; expireAt; $currentExpireAt)
			SET PROCESS VARIABLE:C370(server_pid; expireAt; ($currentExpireAt+(60*1)))
			
		Else 
			server_pid:=Execute on server:C373("ams_PurgeBtn"; <>lMinMemPart; process_name; "init")
			If (False:C215)
				ams_PurgeBtn
			End if 
			DELAY PROCESS:C323(Current process:C322; 30)  //give the server a moment to start
		End if 
		
		CLEAR SEMAPHORE:C144(process_semaphore)
		
	: ($msg="init")  //start the server process
		//interprocess flags
		C_BOOLEAN:C305(serverMethodDone)
		serverMethodDone:=False:C215
		
		C_LONGINT:C283(expireAt)
		expireAt:=TSTimeStamp+(60*60*2)  //time stamp is in seconds so this is 2 hours
		
		// //////////////////////////////
		//populate the arrays with whatever
		ams_Purge_Server_Side
		//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
		
		serverMethodDone:=True:C214  //tell the client that the arrays are ready
		
		While (TSTimeStamp<expireAt)  //wait for the client to get the arrays
			IDLE:C311
			DELAY PROCESS:C323(Current process:C322; (60*10))
		End while 
		
	: ($msg="exchange")  //suck the arrays from the server
		C_TIME:C306($timeOutAt)
		$timeOutAt:=Current time:C178+?02:01:00?
		Repeat   //waiting until server says it ready
			GET PROCESS VARIABLE:C371(server_pid; serverMethodDone; serverMethodDone_local)
			If (Not:C34(serverMethodDone_local))
				zwStatusMsg("SERVER REQUEST"; "Done yet?")
				DELAY PROCESS:C323(Current process:C322; 30)
			End if 
		Until (serverMethodDone_local) | (Current time:C178>$timeOutAt)
		
		// //////////////////////////////
		
		If (Current time:C178<$timeOutAt)
			doPurgeChk4Hole
		Else 
			zwStatusMsg("SERVER REQUEST"; "Timed Out!")
		End if 
		zwStatusMsg("SERVER REQUEST"; "Done!")
		
	: ($msg="die!")  //called by On Server Shutdown
		server_pid:=Process number:C372(process_name; *)
		If (server_pid#0)
			SET PROCESS VARIABLE:C370(server_pid; expireAt; 0)
			DELAY PROCESS:C323(server_pid; 0)  //give the server a moment to start
		End if 
		utl_Logfile("server.log"; process_name+"(die!) pid = "+String:C10(server_pid)+" called.")
		
	Else   //normal sequence of calls __main__ 
		ams_PurgeBtn("client-prep")  //;"STORED-PROCEDURE-SEMEPHORE";"STORED-PROCEDURE-NAME")  `set flags and wait your turn
		ams_PurgeBtn("available?")  //start or get servers pid then release the semaphore
		ams_PurgeBtn("exchange")  //suck the arrays from the server
End case 
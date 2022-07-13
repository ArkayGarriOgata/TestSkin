//%attributes = {}

// Method: PSG_ServerArrays ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/25/14, 11:24:19
// ----------------------------------------------------
// Description
// based on pattern_StoredProcedure
// Call procedure without parameters to have it run itself
// ----------------------------------------------------
// ----------------------------------------------------

C_TEXT:C284($1; $2; $3; process_name; process_semaphore)  //$1 is the message, $2 is a tramp used to find an element in the array
C_BOOLEAN:C305($0)
C_LONGINT:C283(server_pid; $hit; $i; $numCPN; $currentExpireAt; expireAt; $rtn_value)

If (Count parameters:C259>0)
	$msg:=$1
Else 
	$msg:="do-the-else"
End if 
process_semaphore:="GLUE-ARRAY-SEMEPHORE"
process_name:="GLUE-ARRAYS"
$0:=False:C215

Case of 
	: ($msg="client-prep")  //set flags and wait your turn
		//put up a block until server pid has started or its id discovered
		While (Semaphore:C143(process_semaphore))
			DELAY PROCESS:C323(Current process:C322; 10)
		End while 
		
		C_BOOLEAN:C305(serverMethodDone_local)
		serverMethodDone_local:=False:C215  //reset by server
		
	: ($msg="available?")  //decide if it needs started or can use existing
		server_pid:=Process number:C372(process_name; *)
		
		If (server_pid#0)
			//add a minute to expire time to be safe
			GET PROCESS VARIABLE:C371(server_pid; expireAt; $currentExpireAt)
			SET PROCESS VARIABLE:C370(server_pid; expireAt; ($currentExpireAt+(60*1)))
			
		Else 
			server_pid:=Execute on server:C373("PSG_ServerArrays"; <>lMinMemPart; process_name; "init")
			If (False:C215)
				PSG_ServerArrays
			End if 
			DELAY PROCESS:C323(Current process:C322; 30)  //give the server a moment to start
		End if 
		
		CLEAR SEMAPHORE:C144(process_semaphore)
		
	: ($msg="init")  //start the server process
		//interprocess flags
		C_BOOLEAN:C305(serverMethodDone)
		serverMethodDone:=False:C215
		
		C_LONGINT:C283(expireAt)
		expireAt:=TSTimeStamp+(60*15)  //time stamp is in seconds so this is 15 minutes
		// if data is changed in glue schedule dialog this stored procedure will be told
		// to die; however, releases can change and job progress can change so it 
		// wouldn't be prudent to stay alive for too long.
		
		//alert(ts2string(expireAt))
		// //////////////////////////////
		//populate the arrays with whatever
		$rtn_value:=PSG_MasterArray("new")
		$rtn_value:=PSG_MasterArray("load")
		$rtn_value:=PSG_MasterArray("consolidate")
		$rtn_value:=PSG_MasterArray("more_details")
		
		//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
		
		serverMethodDone:=True:C214  //tell the client that the arrays are ready
		
		While (TSTimeStamp<expireAt)  //wait for the client to get the arrays
			IDLE:C311
			DELAY PROCESS:C323(Current process:C322; (60*10))
		End while 
		
		//beep
		//ALERT(TS2String (TSTimeStamp))
		
		$0:=serverMethodDone
		
	: ($msg="exchange")  //suck the arrays from the server
		C_TIME:C306($timeOutAt)
		$timeOutAt:=Current time:C178+?00:02:00?
		Repeat   //waiting until server says it ready
			GET PROCESS VARIABLE:C371(server_pid; serverMethodDone; serverMethodDone_local)
			If (Not:C34(serverMethodDone_local))
				zwStatusMsg("SERVER REQUEST"; "Done yet?")
				DELAY PROCESS:C323(Current process:C322; 30)
			End if 
		Until (serverMethodDone_local) | (Current time:C178>$timeOutAt)
		zwStatusMsg("SERVER REQUEST"; "Done!")
		// //////////////////////////////
		//load the arrays
		$rtn_value:=PSG_MasterArray("new")  //make local copy of arrays
		If (Current time:C178<$timeOutAt)
			$rtn_value:=PSG_MasterArray("get_from_server"; server_pid)  //GET PROCESS VARIABLE(server_pid;aServer;aLocal)
			$0:=True:C214
		Else 
			zwStatusMsg("SERVER REQUEST"; "Timed Out!")
		End if 
		
	: ($msg="show")  //display local arrays in dialog
		//display the list
		$numCPN:=Size of array:C274(aLocal)
		SORT ARRAY:C229(aLocal; >)
		utl_LogIt("init")
		utl_LogIt("Released  "+Char:C90(9)+"Product Code ["+String:C10($numCPN)+"]")
		
		For ($i; 1; $numCPN)
			utl_LogIt("-> "+Char:C90(9)+aLocal{$i})
		End for 
		utl_LogIt("show")
		
	: ($msg="lookup")  //find a local element in the array
		$hit:=Find in array:C230(aCPN; $2)
		$0:=($hit>-1)
		
	: ($msg="die!")  //called by On Server Shutdown
		server_pid:=Process number:C372(process_name; *)
		If (server_pid#0)
			SET PROCESS VARIABLE:C370(server_pid; expireAt; 0)
			DELAY PROCESS:C323(server_pid; 30)  //give the server a moment to start
			utl_Logfile("server.log"; process_name+"(die!) pid = "+String:C10(server_pid)+" called.")
		End if 
		
	: ($msg="reload")  //***TODO
		PSG_ServerArrays("die!")
		DELAY PROCESS:C323(Current process:C322; 30)
		server_pid:=Process number:C372(process_name; *)
		PSG_ServerArrays
		
		
	Else   //normal sequence of calls __main__ 
		PSG_ServerArrays("client-prep")  //;"STORED-PROCEDURE-SEMEPHORE";"STORED-PROCEDURE-NAME")  `set flags and wait your turn
		PSG_ServerArrays("available?")  //start or get servers pid then release the semaphore
		PSG_ServerArrays("exchange")  //suck the arrays from the server
End case 
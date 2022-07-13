//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 03/13/07, 08:52:13
// ----------------------------------------------------
// Method: REL_getRecertificationRequired()  --> 
// Description
// find releases that may need to ship with inventory that is 6 months old or older
//102907 mlb exclude items that have been recertified within 6 months
// ----------------------------------------------------

C_TEXT:C284($msg; $1; $2; process_name)
C_LONGINT:C283(<>SERVER_PID_RECERT; $hit; $i; $numCPN; $currentExpireAt; expireAt)
C_BOOLEAN:C305(serverMethodDone; $serverMethodDone; $0)

process_name:="RecertificationRequiredArray"
$0:=False:C215

If (Count parameters:C259>0)
	$msg:=$1
Else 
	$msg:="do-the-else"
End if 

Case of 
	: ($msg="available?")  //decide if it needs started or can use existing
		<>SERVER_PID_RECERT:=Process number:C372(process_name; *)
		
		If (<>SERVER_PID_RECERT#0)
			//add a minute to expire time to be safe
			GET PROCESS VARIABLE:C371(<>SERVER_PID_RECERT; expireAt; $currentExpireAt)
			SET PROCESS VARIABLE:C370(<>SERVER_PID_RECERT; expireAt; ($currentExpireAt+(60*1)))
			
		Else 
			utl_LogfileServer(<>zResp; "REL_getRecertificationRequired exec"; "fg_pick.log")
			<>SERVER_PID_RECERT:=Execute on server:C373("REL_getRecertificationRequired"; <>lMinMemPart; process_name; "init")
			If (False:C215)
				REL_getRecertificationRequired
			End if 
			DELAY PROCESS:C323(Current process:C322; 30)  //give the server a moment to start
		End if 
		CLEAR SEMAPHORE:C144("StartUp_Recert_PID")
		
	: ($msg="client-prep")  //set flags and wait your turn
		//put up a block until server pid has started or its id discovered
		While (Semaphore:C143("StartUp_Recert_PID"))
			DELAY PROCESS:C323(Current process:C322; 10)
		End while 
		
		serverMethodDone:=False:C215  //reset by server
		serverKeepAlive:=True:C214  //used to kill server pid
		
	: ($msg="init")  //start the server process
		//interprocess flags
		C_BOOLEAN:C305(serverMethodDone)
		serverMethodDone:=False:C215
		
		//populate the arrays with items that need recert and their next release
		ARRAY TEXT:C222(aCPN_ReCert; 0)
		ARRAY DATE:C224(aCPN_ReCertReleased; 0)
		
		C_LONGINT:C283(expireAt)  //stay alive for 2 hours, then next call from client will re-init
		expireAt:=TSTimeStamp+(60*60*2)
		
		C_DATE:C307($cutOffDate; $glued)
		$cutOffDate:=Add to date:C393(4D_Current_date; 0; -6; 0)
		
		//find inventory that would need to be recertified
		READ ONLY:C145([Finished_Goods_Locations:35])  //[Finished_Goods_Locations]Certified
		//ALL RECORDS([Finished_Goods_Locations])
		//102907 mlb exclude items that have been recertified within 6 months
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Certified:41<$cutOffDate)
		ARRAY TEXT:C222($aJobit; 0)
		DISTINCT VALUES:C339([Finished_Goods_Locations:35]Jobit:33; $aJobit)
		For ($i; 1; Size of array:C274($aJobit))
			$glued:=JMI_getGlueDate($aJobit{$i})
			If ($glued>$cutOffDate)  // & ($glued#!00/00/00!)
				$aJobit{$i}:="New"  //not interested this job
			End if 
		End for 
		//get rid of new jobs
		SORT ARRAY:C229($aJobit; >)
		$hit:=Find in array:C230($aJobit; "New")
		If ($hit>1)  // Modified by: Mel Bohince (8/5/15) protect indice out of range
			ARRAY TEXT:C222($aJobit; ($hit-1))
		End if 
		
		//get the product codes with old jobs
		QUERY WITH ARRAY:C644([Finished_Goods_Locations:35]Jobit:33; $aJobit)
		
		DISTINCT VALUES:C339([Finished_Goods_Locations:35]ProductCode:1; aCPN_ReCert)
		$numCPN:=Size of array:C274(aCPN_ReCert)
		
		//find their next release
		ARRAY DATE:C224(aCPN_ReCertReleased; $numCPN)
		For ($i; 1; $numCPN)
			$released:=REL_getNextRelease(aCPN_ReCert{$i})
			If ($released>!00-00-00!)
				aCPN_ReCertReleased{$i}:=$released
			Else 
				aCPN_ReCert{$i}:="ZZZzzzZZZzzzZZZ"  //"~~who_cares"
				aCPN_ReCertReleased{$i}:=<>MAGIC_DATE
			End if 
		End for 
		
		//get rid of cpn's without releases
		SORT ARRAY:C229(aCPN_ReCert; aCPN_ReCertReleased; >)
		$hit:=Find in array:C230(aCPN_ReCert; "ZZZzzzZZZzzzZZZ")
		If ($hit>0)
			ARRAY TEXT:C222(aCPN_ReCert; ($hit-1))
			ARRAY DATE:C224(aCPN_ReCertReleased; ($hit-1))
		End if 
		$numCPN:=Size of array:C274(aCPN_ReCert)
		
		serverMethodDone:=True:C214  //tell the client that the arrays are ready
		
		While (TSTimeStamp<expireAt)  //wait for the client to get the arrays
			IDLE:C311
			DELAY PROCESS:C323(Current process:C322; (60*10))
		End while 
		//utl_Logfile ("server.log";"RecertificationRequiredArray ended")
		
	: ($msg="exchange")  //suck the arrays from the server
		C_TIME:C306($timeOutAt)
		$timeOutAt:=Current time:C178+?00:01:00?
		Repeat   //waiting until server says it ready
			GET PROCESS VARIABLE:C371(<>SERVER_PID_RECERT; serverMethodDone; $serverMethodDone)
			If (Not:C34($serverMethodDone))
				zwStatusMsg("SERVER REQUEST"; "Done yet?")
				DELAY PROCESS:C323(Current process:C322; 30)
			End if 
		Until ($serverMethodDone) | (Current time:C178>$timeOutAt)
		zwStatusMsg("SERVER REQUEST"; "Done!")
		
		//load the arrays
		ARRAY TEXT:C222(aCPNclient; 0)
		ARRAY DATE:C224(aDateShip; 0)
		If (Current time:C178<$timeOutAt)
			GET PROCESS VARIABLE:C371(<>SERVER_PID_RECERT; aCPN_ReCert; aCPNclient; aCPN_ReCertReleased; aDateShip)
			$0:=True:C214
		Else 
			zwStatusMsg("SERVER REQUEST"; "Timed Out!")
		End if 
		
	: ($msg="show")  //display arrays in dialog
		//display the list
		$numCPN:=Size of array:C274(aCPNclient)
		SORT ARRAY:C229(aDateShip; aCPNclient; >)
		utl_LogIt("init")
		utl_LogIt("Released  "+Char:C90(9)+"Product Code ["+String:C10($numCPN)+"]")
		
		For ($i; 1; $numCPN)
			utl_LogIt(String:C10(aDateShip{$i}; Internal date short:K1:7)+Char:C90(9)+aCPNclient{$i})
		End for 
		utl_LogIt("show")
		
	: ($msg="lookup")  //find an element in the array, if found re-cert required
		$hit:=Find in array:C230(aCPNclient; $2)
		$0:=($hit>-1)
		
	: ($msg="local")
		//populate the arrays with items that need recert and their next release
		ARRAY TEXT:C222(aCPNclient; 0)
		ARRAY DATE:C224(aDateShip; 0)
		C_DATE:C307($cutOffDate; $glued)
		
		$cutOffDate:=Add to date:C393(4D_Current_date; 0; -6; 0)
		
		//find inventory that would need to be recertified
		READ ONLY:C145([Finished_Goods_Locations:35])  //[Finished_Goods_Locations]Certified
		//ALL RECORDS([Finished_Goods_Locations])
		//102907 mlb exclude items that have been recertified within 6 months
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Certified:41<$cutOffDate)
		ARRAY TEXT:C222($aJobit; 0)
		DISTINCT VALUES:C339([Finished_Goods_Locations:35]Jobit:33; $aJobit)
		For ($i; 1; Size of array:C274($aJobit))
			$glued:=JMI_getGlueDate($aJobit{$i})
			If ($glued>$cutOffDate)  // & ($glued#!00/00/00!)
				$aJobit{$i}:="New"  //not interested this job
			End if 
		End for 
		//get rid of new jobs
		SORT ARRAY:C229($aJobit; >)
		$hit:=Find in array:C230($aJobit; "New")
		ARRAY TEXT:C222($aJobit; ($hit-1))
		
		//get the product codes with old jobs
		QUERY WITH ARRAY:C644([Finished_Goods_Locations:35]Jobit:33; $aJobit)
		
		DISTINCT VALUES:C339([Finished_Goods_Locations:35]ProductCode:1; aCPNclient)
		$numCPN:=Size of array:C274(aCPNclient)
		
		//find their next release
		ARRAY DATE:C224(aDateShip; $numCPN)
		For ($i; 1; $numCPN)
			$released:=REL_getNextRelease(aCPNclient{$i})
			If ($released>!00-00-00!)
				aDateShip{$i}:=$released
			Else 
				aCPNclient{$i}:="ZZZzzzZZZzzzZZZ"  //"~~who_cares"
				aDateShip{$i}:=<>MAGIC_DATE
			End if 
		End for 
		
		//get rid of cpn's without releases
		SORT ARRAY:C229(aCPNclient; aDateShip; >)
		$hit:=Find in array:C230(aCPNclient; "ZZZzzzZZZzzzZZZ")
		If ($hit>0)
			ARRAY TEXT:C222(aCPNclient; ($hit-1))
			ARRAY DATE:C224(aDateShip; ($hit-1))
		End if 
		$numCPN:=Size of array:C274(aCPNclient)
		
	: ($msg="die!")  //called by On Server Shutdown
		server_pid:=Process number:C372(process_name; *)
		If (server_pid#0)
			SET PROCESS VARIABLE:C370(server_pid; expireAt; 0)
			DELAY PROCESS:C323(server_pid; 0)  //give the server a moment to start
		End if 
		utl_Logfile("server.log"; "REL_getRecertificationRequired (die!) pid = "+String:C10(server_pid)+" called.")
		
	Else 
		REL_getRecertificationRequired("client-prep")  //set flags and wait your turn
		REL_getRecertificationRequired("available?")  //start or get servers pid then release the semaphore
		REL_getRecertificationRequired("exchange")
End case 
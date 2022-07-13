//%attributes = {"publishedWeb":true}
//Procedure: CostCtrCurInit(effectivity)  120397  MLB
//called by CostCtrCurrent
//create the structure
//•052198  MLB  add labor and burden
//•090399  mlb  UPR 2052 add scrap to arrays
// Modified by Mel Bohince on 3/21/07 at 00:00:55 : chg to stored procedure
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 03/20/07, 23:03:32
// ----------------------------------------------------
// base on: pattern_StoredProcedure()  --> 
// Description
// skeleton of a structured, stay-alive stored procedure
//
// ----------------------------------------------------
// Call procedure without parameters to have it run itself
// ----------------------------------------------------

C_TEXT:C284($1; $2; $3; process_name; process_semaphore)  //$1 is the message, $2 is a tramp used to find an element in the array
C_BOOLEAN:C305($0)
C_LONGINT:C283(server_pid; $hit; $i; $numCPN; $currentExpireAt; expireAt)
C_DATE:C307(dateEffective)

process_semaphore:="COST-CENTER-SEMEPHORE"
process_name:="CostCenterStandards"
$0:=False:C215

Case of 
	: ($1="effective")  //this is for legacy code
		C_TEXT:C284(sEffective)  //not used, here for Find in Database
		dateEffective:=Date:C102($2)
		
		//: ($1="client-prep")  `set flags and wait your turn
		//put up a block until server pid has started or its id discovered
		While (Semaphore:C143(process_semaphore))
			DELAY PROCESS:C323(Current process:C322; 10)
		End while 
		
		C_BOOLEAN:C305(serverMethodDone_local)
		serverMethodDone_local:=False:C215  //reset by server
		
		//: ($1="available?")  `decide if it needs started or can use existing
		server_pid:=Process number:C372(process_name; *)
		
		If (server_pid#0)
			//add a minute to expire time to be safe
			GET PROCESS VARIABLE:C371(server_pid; expireAt; $currentExpireAt)
			SET PROCESS VARIABLE:C370(server_pid; expireAt; ($currentExpireAt+(60*1)))
			
		Else 
			server_pid:=Execute on server:C373("CostCtrCurInit"; <>lMinMemPart; process_name; "init"; String:C10(dateEffective; Internal date short:K1:7))
			If (False:C215)
				CostCtrCurInit
			End if 
			DELAY PROCESS:C323(Current process:C322; 30)  //give the server a moment to start
		End if 
		
		CLEAR SEMAPHORE:C144(process_semaphore)
		
		//: ($1="exchange")  `suck the arrays from the server
		C_TIME:C306($timeOutAt)
		$timeOutAt:=Current time:C178+?00:01:00?
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
		CostCtrCurrent("kill")
		If (Current time:C178<$timeOutAt)
			GET PROCESS VARIABLE:C371(server_pid; aStdCC; aStdCC; aOOP; aOOP; aLabor; aLabor; aBurden; aBurden; aCostCtrDes; aCostCtrDes; aScrap; aScrap; aCostCtrEff; aCostCtrEff; aCostCtrDept; aCostCtrDept; aCostCtrGroup; aCostCtrGroup; aDownBudget; aDownBudget)
			$0:=True:C214
		Else 
			zwStatusMsg("SERVER REQUEST"; "Timed Out!")
		End if 
		//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
		//CostCtrCurInit ("show")`test it
		
	: ($1="init")  //start the server process
		//interprocess flags
		C_BOOLEAN:C305(serverMethodDone)
		serverMethodDone:=False:C215
		
		C_LONGINT:C283(expireAt)
		expireAt:=TSTimeStamp+(60*60*2)
		
		// //////////////////////////////
		//populate the arrays with whatever
		CostCtrCurrent("kill")
		
		dateEffective:=Date:C102($2)
		READ ONLY:C145([Cost_Centers:27])
		If (dateEffective=!00-00-00!)
			ALL RECORDS:C47([Cost_Centers:27])
		Else 
			QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]EffectivityDate:13<=dateEffective)
		End if 
		
		ARRAY TEXT:C222($aCCs; 0)
		ARRAY DATE:C224($aEffDate; 0)
		ARRAY REAL:C219($aLabor; 0)
		ARRAY REAL:C219($aBurden; 0)
		ARRAY REAL:C219($aScrap; 0)
		ARRAY TEXT:C222($aDesc; 0)
		ARRAY TEXT:C222($aDept; 0)
		ARRAY TEXT:C222($aGroup; 0)
		ARRAY REAL:C219($aDown; 0)
		SELECTION TO ARRAY:C260([Cost_Centers:27]ID:1; $aCCs; [Cost_Centers:27]EffectivityDate:13; $aEffDate; [Cost_Centers:27]Description:3; $aDesc; [Cost_Centers:27]ScrapExcessCost:32; $aScrap; [Cost_Centers:27]cc_Group:2; $aDept; [Cost_Centers:27]cc_Group:2; $aGroup; [Cost_Centers:27]DownBudget:11; $aDown)
		
		Case of   //•090399  mlb  UPR 2052
			: (Count parameters:C259<=2)
				SELECTION TO ARRAY:C260([Cost_Centers:27]MHRlaborSales:4; $aLabor; [Cost_Centers:27]MHRburdenSales:5; $aBurden)
			: ($3="Sales")
				SELECTION TO ARRAY:C260([Cost_Centers:27]MHRlaborSales:4; $aLabor; [Cost_Centers:27]MHRburdenSales:5; $aBurden)
			: ($3="Haup")
				SELECTION TO ARRAY:C260([Cost_Centers:27]MHRlaborHauppauge:59; $aLabor; [Cost_Centers:27]MHRburdenHauppauge:60; $aBurden)
			: ($3="Roan")
				SELECTION TO ARRAY:C260([Cost_Centers:27]MHRlaborRoanoke:61; $aLabor; [Cost_Centers:27]MHRburdenRoanoke:62; $aBurden)
		End case 
		
		REDUCE SELECTION:C351([Cost_Centers:27]; 0)
		//*      Use the OOP with the latest effectivity date
		$numCC:=Size of array:C274($aEffDate)
		ARRAY TEXT:C222(aStdCC; $numCC)  //create a structure to hold the current rates by CC
		ARRAY REAL:C219(aOOP; $numCC)
		ARRAY REAL:C219(aLabor; $numCC)
		ARRAY REAL:C219(aBurden; $numCC)
		ARRAY REAL:C219(aScrap; $numCC)
		ARRAY TEXT:C222(aCostCtrDes; $numCC)
		ARRAY DATE:C224(aCostCtrEff; $numCC)
		ARRAY TEXT:C222(aCostCtrDept; $numCC)
		ARRAY TEXT:C222(aCostCtrGroup; $numCC)
		ARRAY REAL:C219(aDownBudget; $numCC)
		$next:=0
		
		For ($i; 1; $numCC)
			$hit:=Find in array:C230(aStdCC; $aCCs{$i})
			If ($hit=-1)  //not found, so create
				$next:=$next+1
				aStdCC{$next}:=$aCCs{$i}
				$hit:=$next
			End if 
			
			If ($aEffDate{$i}>aCostCtrEff{$hit})
				aCostCtrEff{$hit}:=$aEffDate{$i}
				aOOP{$hit}:=$aLabor{$i}+$aBurden{$i}
				aLabor{$hit}:=$aLabor{$i}
				aBurden{$hit}:=$aBurden{$i}
				aCostCtrDes{$hit}:=$aDesc{$i}
				aScrap{$hit}:=$aScrap{$i}
				aCostCtrDept{$hit}:=Substring:C12($aDept{$i}; 4)
				aCostCtrGroup{$hit}:=$aGroup{$i}
				aDownBudget{$hit}:=$aDown{$i}
			End if 
		End for 
		
		ARRAY TEXT:C222(aStdCC; $next)  //shrink
		ARRAY REAL:C219(aOOP; $next)  //shrink
		ARRAY REAL:C219(aLabor; $next)
		ARRAY REAL:C219(aBurden; $next)
		ARRAY REAL:C219(aScrap; $next)
		ARRAY TEXT:C222(aCostCtrDes; $next)
		ARRAY DATE:C224(aCostCtrEff; $next)
		ARRAY TEXT:C222(aCostCtrDept; $next)
		ARRAY TEXT:C222(aCostCtrGroup; $next)
		ARRAY REAL:C219(aDownBudget; $next)
		ARRAY TEXT:C222($aCCs; 0)  //dispose
		ARRAY DATE:C224($aEffDate; 0)  //dispose
		ARRAY REAL:C219($aLabor; 0)
		ARRAY REAL:C219($aBurden; 0)
		ARRAY REAL:C219($aScrap; 0)
		ARRAY TEXT:C222($aDesc; 0)
		ARRAY TEXT:C222($aDept; 0)
		ARRAY TEXT:C222($aGroup; 0)
		ARRAY REAL:C219($aDown; 0)
		
		//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
		
		serverMethodDone:=True:C214  //tell the client that the arrays are ready
		
		While (TSTimeStamp<expireAt)  //wait for the client to get the arrays
			IDLE:C311
			DELAY PROCESS:C323(Current process:C322; (60*10))
		End while 
		//utl_Logfile ("server.log";"CostCenterStandards ended")
		
	: ($1="show")  //display local arrays in dialog
		// //////////////////////////////
		//display the list
		$numCPN:=Size of array:C274(aStdCC)
		CostCtrCurrent("sort")
		utl_LogIt("init")
		utl_LogIt("C/C  "+Char:C90(9)+"Description ["+String:C10($numCPN)+"]")
		
		For ($i; 1; $numCPN)
			utl_LogIt(aStdCC{$i}+Char:C90(9)+aCostCtrDes{$i})
		End for 
		utl_LogIt("show")
		//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
		
	: ($1="lookup")  //find a local element in the array
		// //////////////////////////////
		//see CostCtrCurrent($2)
		//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
	: ($1="die!")  //called by On Server Shutdown
		server_pid:=Process number:C372(process_name; *)
		If (server_pid#0)
			SET PROCESS VARIABLE:C370(server_pid; expireAt; 0)
			DELAY PROCESS:C323(server_pid; 0)  //give the server a moment to start
		End if 
		utl_Logfile("server.log"; "CostCtrCurInit (die!) pid = "+String:C10(server_pid)+" called.")
		
	Else   //normal sequence of calls __main__ 
		CostCtrCurInit("client-prep")  //set flags and wait your turn
		CostCtrCurInit("available?")  //start or get servers pid then release the semaphore
		CostCtrCurInit("exchange")  //suck the arrays from the server
		CostCtrCurInit("show")
End case 
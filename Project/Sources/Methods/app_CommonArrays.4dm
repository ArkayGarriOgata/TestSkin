//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 03/21/07, 15:27:38
// ----------------------------------------------------
// Method: app_CommonArrays()  --> 
// Description
// based on pattern_StoredProcedure
// ----------------------------------------------------
//Modified by:  Garri Ogata 03/08/2022 Added case check for valid table

C_TEXT:C284($1; $2; $3; process_name; process_semaphore; $STRcountCustomers)  //$1 is the message, $2 is a tramp used to find an element in the array
C_BOOLEAN:C305($0)
C_LONGINT:C283(server_pid; $hit; $i; $numCPN; $currentExpireAt; expireAt)

process_semaphore:="COMMON-ARRAY-SEMEPHORE"
process_name:="CommonArrays"
$0:=False:C215

Case of 
	: ($1="client-prep")  //set flags and wait your turn
		MESSAGE:C88(Char:C90(13)+"client-prep")
		ARRAY TEXT:C222(<>CostCenterEquivalent; 0)
		ARRAY TEXT:C222(<>CostCenterValid; 0)
		ARRAY TEXT:C222(<>aGenDepts; 0)
		ARRAY LONGINT:C221(<>aOffSet; 0)
		ARRAY TEXT:C222(<>EstCommKey; 0)
		<>EL_Companies:=""
		
		//put up a block until server pid has started or its id discovered
		//While (Semaphore(process_semaphore))
		//DELAY PROCESS(Current process;10)
		//End while 
		
		C_BOOLEAN:C305(serverMethodDone_local)
		serverMethodDone_local:=False:C215  //reset by server
		
	: ($1="available?")  //decide if it needs started or can use existing
		MESSAGE:C88(Char:C90(13)+"server ready?")
		server_pid:=Process number:C372(process_name; *)
		
		If (server_pid=0)
			MESSAGE:C88(Char:C90(13)+"server ready?  NO")
			server_pid:=Execute on server:C373("app_CommonArrays"; <>lMinMemPart; process_name; "init")
			DELAY PROCESS:C323(Current process:C322; 30)  //give the server a moment to start
		End if 
		
		//CLEAR SEMAPHORE(process_semaphore)
		
	: ($1="init")  //start the server process
		//interprocess flags
		C_BOOLEAN:C305(serverMethodDone)
		serverMethodDone:=False:C215
		//die after 2 hours
		expireAt:=TSTimeStamp+(60*60*2)
		// //////////////////////////////
		ARRAY TEXT:C222(aCostCenterEquivalent; 0)
		ARRAY TEXT:C222(aCostCenterValid; 0)
		ARRAY TEXT:C222(aGenDepts; 0)
		ARRAY LONGINT:C221(aOffSet; 0)
		ARRAY TEXT:C222(aEstCommKey; 0)
		sEL_Companies:=""
		
		//populate the arrays with whatever
		READ ONLY:C145([Salesmen:32])
		QUERY:C277([Salesmen:32]; [Salesmen:32]Active:12=True:C214)
		$j:=Records in selection:C76([Salesmen:32])
		ARRAY TEXT:C222($aID; $j)
		ARRAY TEXT:C222($aLast; $j)
		ARRAY TEXT:C222($aFirst; $j)
		SELECTION TO ARRAY:C260([Salesmen:32]ID:1; $aID; [Salesmen:32]LastName:2; $aLast; [Salesmen:32]FirstName:3; $aFirst)
		SORT ARRAY:C229($aLast; $aID; $aFirst; >)
		ARRAY TEXT:C222($aRepList; $j)
		For ($i; 1; $j)
			$aRepList{$i}:=Change string:C234("    "; $aID{$i}; 1)+" - "+$aLast{$i}+", "+$aFirst{$i}
		End for 
		ARRAY TO LIST:C287($aRepList; "SalesReps")
		REDUCE SELECTION:C351([Salesmen:32]; 0)  //•022597  MLB  UPR §
		
		
		ARRAY LONGINT:C221(aOffSet; Get last table number:C254)  //number to be added when using sequence command
		READ ONLY:C145([x_id_numbers:3])
		
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			ALL RECORDS:C47([x_id_numbers:3])  //number to be added when using sequence command
			For ($i; 1; Records in selection:C76([x_id_numbers:3]))
				If ([x_id_numbers:3]Table_Number:1<999) & (Is table number valid:C999($i))
					aOffSet{[x_id_numbers:3]Table_Number:1}:=[x_id_numbers:3]Seq_Offset:3
				End if 
				NEXT RECORD:C51([x_id_numbers:3])
			End for 
			
		Else 
			ALL RECORDS:C47([x_id_numbers:3])
			ARRAY LONGINT:C221($_Seq_Offset; 0)
			ARRAY INTEGER:C220($_Table_Number; 0)
			
			SELECTION TO ARRAY:C260([x_id_numbers:3]Seq_Offset:3; $_Seq_Offset; [x_id_numbers:3]Table_Number:1; $_Table_Number)
			
			For ($i; 1; Size of array:C274($_Table_Number); 1)
				
				//If ($_Table_Number{$i}<999) & (Is table number valid($i))
				//aOffSet{$_Table_Number{$i}}:=$_Seq_Offset{$i}
				//End if (Replaced with case statement below)
				
				Case of   //Valid table
						
					: (Not:C34(Is table number valid:C999($i)))
					: ($_Table_Number{$i}<1)
					: ($_Table_Number{$i}>999)
						
					Else   //Valid
						
						aOffSet{$_Table_Number{$i}}:=$_Seq_Offset{$i}
						
				End case   //Done valid table
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 First record
		
		COPY ARRAY:C226(aOffSet; <>aOffSet)
		
		READ ONLY:C145([Raw_Materials_Groups:22])
		QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]UseForEst:12=True:C214)
		ARRAY TEXT:C222(aEstCommKey; Records in selection:C76([Raw_Materials_Groups:22]))  //• 6/3/97 cs set up array for estimating commodity keys
		SELECTION TO ARRAY:C260([Raw_Materials_Groups:22]Commodity_Key:3; aEstCommKey)  //this wil be used in various RM selction procesess
		uClearSelection(->[Raw_Materials_Groups:22])
		
		//• 9/22/97 cs bulid array of general dept codes
		READ ONLY:C145([y_accounting_departments:4])
		QUERY:C277([y_accounting_departments:4]; [y_accounting_departments:4]UseForApprvDept:2=True:C214)
		SELECTION TO ARRAY:C260([y_accounting_departments:4]DepartmentID:1; $Id; [y_accounting_departments:4]Description:4; $Desc)
		ARRAY TEXT:C222(aGenDepts; Size of array:C274($id))
		For ($i; 1; Size of array:C274($id))
			aGenDepts{$i}:=$Id{$i}+" - "+$Desc{$i}
		End for 
		SORT ARRAY:C229(aGenDepts; >)
		
		C_BOOLEAN:C305($haveEL)
		sEL_Companies:=""
		$haveEL:=ELC_isEsteeLauderCompany
		<>EL_Companies:=sEL_Companies
		
		$STRcountCustomers:=Cust_getNameCached("init")  // Modified by: Mel Bohince (10/4/17) 
		
		CostCenterEquivalent
		
		serverMethodDone:=True:C214  //tell the client that the arrays are ready
		
		While (TSTimeStamp<expireAt)  //wait for the client to get the arrays
			IDLE:C311
			DELAY PROCESS:C323(Current process:C322; (60*10))
		End while 
		//utl_Logfile ("server.log";"app_CommonArrays ended")
		
	: ($1="exchange")  //suck the arrays from the server
		MESSAGE:C88(Char:C90(13)+"Exchanging data")
		C_TIME:C306($timeOutAt)
		$timeOutAt:=Current time:C178+?00:01:00?
		Repeat   //waiting until server says it ready
			GET PROCESS VARIABLE:C371(server_pid; serverMethodDone; serverMethodDone_local)
			If (Not:C34(serverMethodDone_local))
				zwStatusMsg("SERVER REQUEST"; "Done yet?")
				DELAY PROCESS:C323(Current process:C322; 30)
			End if 
		Until (serverMethodDone_local) | (Current time:C178>$timeOutAt)
		BEEP:C151
		zwStatusMsg("SERVER REQUEST"; "Done!")
		
		//load the arrays
		ARRAY TEXT:C222(aLocal; 0)
		If (Current time:C178<$timeOutAt)
			GET PROCESS VARIABLE:C371(server_pid; sEL_Companies; <>EL_Companies; aGenDepts; <>aGenDepts; aEstCommKey; <>EstCommKey; aOffSet; <>aOffSet; aCostCenterValid; <>CostCenterValid; aCostCenterEquivalent; <>CostCenterEquivalent; <>Cust_IDs; <>Cust_IDs; <>Cust_ShortNames; <>Cust_ShortNames; <>Cust_Names; <>Cust_Names)
			$0:=True:C214
		Else 
			zwStatusMsg("SERVER REQUEST"; "Timed Out!")
		End if 
		
	: ($1="die!")  //called by On Server Shutdown
		server_pid:=Process number:C372(process_name; *)
		If (server_pid#0)
			SET PROCESS VARIABLE:C370(server_pid; expireAt; 0)
			DELAY PROCESS:C323(server_pid; 0)  //give the server a moment to start
		End if 
		utl_Logfile("server.log"; "app_CommonArrays (die!) pid = "+String:C10(server_pid)+" called.")
		
End case 
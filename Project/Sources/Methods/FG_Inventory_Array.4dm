//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 02/16/10, 13:56:19
// ----------------------------------------------------
// Method: FG_Inventory_Array
// Description
// cache the inventory for each cpn
// ----------------------------------------------------
// based on: pattern_StoredProcedure()  --> 
// Description
// skeleton of a structured, stay-alive stored procedure
//
// ----------------------------------------------------
// Call procedure without parameters to have it run itself
// ----------------------------------------------------
// Modified by: Mel Bohince (4/26/16) add location of the inventory (outside, plant, vista)
// Modified by: Mel Bohince (8/4/17) added <>aFG_CanShip and "canShip" option so portal doesn't get dirty laundry
// Modified by: Mel Bohince (6/7/18) don't include kills

C_LONGINT:C283(server_pid; $hit; $i; $numCPN; $currentExpireAt; expireAt; $0)
C_TEXT:C284($1; $2; $3; process_name; process_semaphore; $msg)  //$1 is the message, $2 is a tramp used to find an element in the array

If (Count parameters:C259>0)
	$msg:=$1
Else 
	$msg:="do-the-else"
End if 
process_semaphore:="ONHAND-SEMEPHORE"
process_name:="FG_Inventory_Array"

$0:=0

Case of 
	: ($msg="client-prep")  //set flags and wait your turn
		MESSAGE:C88(Char:C90(13)+"client-prep")
		ARRAY TEXT:C222(<>aFG_Key_Code; 0)
		ARRAY LONGINT:C221(<>aFG_On_Hand; 0)
		ARRAY LONGINT:C221(<>aFG_In_Cert; 0)
		ARRAY LONGINT:C221(<>aFG_At_Outside; 0)
		ARRAY LONGINT:C221(<>aFG_At_Plant; 0)
		ARRAY LONGINT:C221(<>aFG_At_Vista; 0)
		ARRAY LONGINT:C221(<>aFG_CanShip; 0)
		
		//put up a block until server pid has started or its id discovered
		//While (Semaphore(process_semaphore))
		//DELAY PROCESS(Current process;10)
		//End while 
		
		C_BOOLEAN:C305(serverMethodDone_local)
		serverMethodDone_local:=False:C215  //reset by server
		
	: ($msg="available?")  //decide if it needs started or can use existing
		MESSAGE:C88(Char:C90(13)+"server ready?")
		server_pid:=Process number:C372(process_name; *)
		
		If (server_pid#0)
			//add a minute to expire time to be safe
			MESSAGE:C88(Char:C90(13)+"server ready? YEP")
			GET PROCESS VARIABLE:C371(server_pid; expireAt; $currentExpireAt)
			SET PROCESS VARIABLE:C370(server_pid; expireAt; ($currentExpireAt+(60*1)))
			
		Else 
			MESSAGE:C88(Char:C90(13)+"server ready? STARTING UP CACHE")
			utl_LogfileServer(<>zResp; "FG_Inventory_Array exec"; "fg_pick.log")
			server_pid:=Execute on server:C373("FG_Inventory_Array"; <>lMinMemPart; process_name; "init")
			If (False:C215)
				FG_Inventory_Array
			End if 
			DELAY PROCESS:C323(Current process:C322; 30)  //give the server a moment to start
		End if 
		
		//CLEAR SEMAPHORE(process_semaphore)
		
	: ($msg="init")  //start the server process
		//interprocess flags
		C_BOOLEAN:C305(serverMethodDone)
		serverMethodDone:=False:C215
		
		C_LONGINT:C283(expireAt)
		expireAt:=TSTimeStamp+(60*60*1)  //stay alive for 1hr
		
		// //////////////////////////////
		//populate the arrays with whatever
		ARRAY TEXT:C222(aFG_Key_Code; 0)
		ARRAY LONGINT:C221(aFG_On_Hand; 0)
		ARRAY LONGINT:C221(aFG_In_Cert; 0)
		ARRAY LONGINT:C221(aFG_At_Outside; 0)
		ARRAY LONGINT:C221(aFG_At_Plant; 0)
		ARRAY LONGINT:C221(aFG_At_Vista; 0)
		ARRAY LONGINT:C221(aFG_CanShip; 0)
		
		READ ONLY:C145([Finished_Goods_Locations:35])
		ALL RECORDS:C47([Finished_Goods_Locations:35])
		DISTINCT VALUES:C339([Finished_Goods_Locations:35]FG_Key:34; aFG_Key_Code)
		$numCPN:=Size of array:C274(aFG_Key_Code)
		ARRAY LONGINT:C221(aFG_On_Hand; $numCPN)
		ARRAY LONGINT:C221(aFG_In_Cert; $numCPN)
		ARRAY LONGINT:C221(aFG_At_Outside; $numCPN)
		ARRAY LONGINT:C221(aFG_At_Plant; $numCPN)
		ARRAY LONGINT:C221(aFG_At_Vista; $numCPN)
		ARRAY LONGINT:C221(aFG_CanShip; $numCPN)
		
		For ($i; 1; $numCPN)
			//ready to ship inventory
			//If (position("ZHLH-Y5-0111";aFG_Key_Code{$i})>0)
			//
			//end if
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]FG_Key:34=aFG_Key_Code{$i}; *)
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]KillStatus:30=0)  // Modified by: Mel Bohince (6/7/18) don't include kills
			ARRAY TEXT:C222($aBins; 0)
			ARRAY LONGINT:C221($aQty; 0)
			SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Location:2; $aBins; [Finished_Goods_Locations:35]QtyOH:9; $aQty)
			REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
			aFG_On_Hand{$i}:=0
			aFG_In_Cert{$i}:=0
			aFG_At_Vista{$i}:=0
			aFG_At_Plant{$i}:=0
			aFG_At_Outside{$i}:=0
			aFG_CanShip{$i}:=0
			
			For ($bin; 1; Size of array:C274($aBins))  //tally
				
				$locationIndicator:=Substring:C12($aBins{$bin}; 4; 1)
				$stateIndicator:=Substring:C12($aBins{$bin}; 1; 2)
				$canShip:=(Position:C15("SHIP"; $aBins{$bin})=0)  //weed out ones that are already staged or not cleaned up
				If ($stateIndicator="FG")
					aFG_On_Hand{$i}:=aFG_On_Hand{$i}+$aQty{$bin}
					If ($canShip)
						aFG_CanShip{$i}:=aFG_CanShip{$i}+$aQty{$bin}
					End if 
				Else 
					aFG_In_Cert{$i}:=aFG_In_Cert{$i}+$aQty{$bin}
				End if 
				
				Case of 
					: ($locationIndicator="V")
						aFG_At_Vista{$i}:=aFG_At_Vista{$i}+$aQty{$bin}
					: ($locationIndicator="R")
						aFG_At_Plant{$i}:=aFG_At_Plant{$i}+$aQty{$bin}
					: ($locationIndicator="O")
						aFG_At_Outside{$i}:=aFG_At_Outside{$i}+$aQty{$bin}
					Else 
						aFG_At_Vista{$i}:=aFG_At_Vista{$i}+$aQty{$bin}
				End case 
				
			End for 
			
			//if(false)
			//QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]FG_Key=aFG_Key_Code{$i};*)
			//QUERY([Finished_Goods_Locations]; & ;[Finished_Goods_Locations]Location="FG@")
			//If (Records in selection([Finished_Goods_Locations])>0)
			//aFG_On_Hand{$i}:=Sum([Finished_Goods_Locations]QtyOH)
			//Else 
			//aFG_On_Hand{$i}:=0
			//End if 
			//  //non-fg inventory
			//QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]FG_Key=aFG_Key_Code{$i};*)
			//QUERY([Finished_Goods_Locations]; & ;[Finished_Goods_Locations]Location#"FG@")
			//If (Records in selection([Finished_Goods_Locations])>0)
			//aFG_In_Cert{$i}:=Sum([Finished_Goods_Locations]QtyOH)
			//Else 
			//aFG_In_Cert{$i}:=0
			//End if 
			//end if
			
		End for 
		
		
		serverMethodDone:=True:C214  //tell the client that the arrays are ready
		
		While (TSTimeStamp<expireAt)  //wait for the client to get the arrays
			IDLE:C311
			DELAY PROCESS:C323(Current process:C322; (60*10))
		End while 
		//utl_Logfile ("server.log";"FG_Inventory_Arrays ended")
		
	: ($msg="exchange")  //suck the arrays from the server
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
		
		//load the arrays
		ARRAY TEXT:C222(<>aFG_Key_Code; 0)
		ARRAY LONGINT:C221(<>aFG_On_Hand; 0)
		ARRAY LONGINT:C221(<>aFG_In_Cert; 0)
		ARRAY LONGINT:C221(<>aFG_At_Outside; 0)
		ARRAY LONGINT:C221(<>aFG_At_Plant; 0)
		ARRAY LONGINT:C221(<>aFG_At_Vista; 0)
		ARRAY LONGINT:C221(<>aFG_CanShip; 0)
		If (Current time:C178<$timeOutAt)
			GET PROCESS VARIABLE:C371(server_pid; aFG_Key_Code; <>aFG_Key_Code; aFG_On_Hand; <>aFG_On_Hand; aFG_In_Cert; <>aFG_In_Cert; aFG_At_Outside; <>aFG_At_Outside; aFG_At_Plant; <>aFG_At_Plant; aFG_At_Vista; <>aFG_At_Vista; aFG_CanShip; <>aFG_CanShip)
			$0:=1
		Else 
			zwStatusMsg("SERVER REQUEST"; "Timed Out!")
			$0:=-1
		End if 
		
	: ($msg="show")  //display local arrays in dialog
		//display the list
		$numCPN:=Size of array:C274(<>aFG_Key_Code)
		SORT ARRAY:C229(<>aFG_Key_Code; <>aFG_On_Hand; <>aFG_In_Cert; <>aFG_At_Outside; <>aFG_At_Plant; <>aFG_At_Vista; <>aFG_CanShip; >)
		utl_LogIt("init")
		utl_LogIt("Product Code"+Char:C90(9)+"On-Hand"+Char:C90(9)+"In-Cert"+Char:C90(9)+"OS"+Char:C90(9)+"Plant"+Char:C90(9)+"Vista"+Char:C90(9)+"CanShip")
		
		For ($i; 1; $numCPN)
			utl_LogIt(<>aFG_Key_Code{$i}+Char:C90(9)+String:C10(<>aFG_On_Hand{$i})+Char:C90(9)+String:C10(<>aFG_In_Cert{$i})+Char:C90(9)+String:C10(<>aFG_At_Outside{$i})+Char:C90(9)+String:C10(<>aFG_At_Plant{$i})+Char:C90(9)+String:C10(<>aFG_At_Vista{$i})+Char:C90(9)+String:C10(<>aFG_CanShip{$i}))
		End for 
		utl_LogIt("show")
		
	: ($msg="lookupFG")  //find a local element in the array
		$hit:=Find in array:C230(<>aFG_Key_Code; $2)
		If ($hit>-1)
			$0:=<>aFG_On_Hand{$hit}
		Else 
			$0:=0
		End if 
		
	: ($msg="lookupEX")  //find a local element in the array
		$hit:=Find in array:C230(<>aFG_Key_Code; $2)
		If ($hit>-1)
			$0:=<>aFG_In_Cert{$hit}
		Else 
			$0:=0
		End if 
		
	: ($msg="lookupVista")  //find a local element in the array
		$hit:=Find in array:C230(<>aFG_Key_Code; $2)
		If ($hit>-1)
			$0:=<>aFG_At_Vista{$hit}
		Else 
			$0:=0
		End if 
		
	: ($msg="lookupPlant")  //find a local element in the array
		$hit:=Find in array:C230(<>aFG_Key_Code; $2)
		If ($hit>-1)
			$0:=<>aFG_At_Plant{$hit}
		Else 
			$0:=0
		End if 
		
	: ($msg="lookupOS")  //find a local element in the array
		$hit:=Find in array:C230(<>aFG_Key_Code; $2)
		If ($hit>-1)
			$0:=<>aFG_At_Outside{$hit}
		Else 
			$0:=0
		End if 
		
	: ($msg="lookupCanShip")  //find a local element in the array
		$hit:=Find in array:C230(<>aFG_Key_Code; $2)
		If ($hit>-1)
			$0:=<>aFG_CanShip{$hit}
		Else 
			$0:=0
		End if 
		
	: ($msg="die!")  //called by On Server Shutdown
		server_pid:=Process number:C372(process_name; *)
		If (server_pid#0)
			SET PROCESS VARIABLE:C370(server_pid; expireAt; 0)
			DELAY PROCESS:C323(server_pid; 0)  //give the server a moment to start
		End if 
		utl_Logfile("server.log"; "FG_Inventory_Array (die!) pid = "+String:C10(server_pid)+" called.")
		
	Else   //normal sequence of calls __main__ 
		FG_Inventory_Array("client-prep")  //set flags and wait your turn
		FG_Inventory_Array("available?")  //start or get servers pid then release the semaphore
		FG_Inventory_Array("exchange")  //suck the arrays from the server
End case 
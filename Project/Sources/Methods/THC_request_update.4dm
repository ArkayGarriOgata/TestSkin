//%attributes = {}

// Method: THC_request_update ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/25/14, 16:48:25
// ----------------------------------------------------
// Description
// 2 params: set flag so server knows to recalc THC on a one-up basis
// 1 param: run as daemon on server, calcing any requested fg's thc's
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (5/8/14) added fifo regen so glue & ship same day have a cost record

READ WRITE:C146([Finished_Goods:26])
C_LONGINT:C283($delay; $error; $server_pid; expireAt; $interval; $loop; $revolution)
process_name:="THC_Updater"

Case of 
	: (Count parameters:C259=2)  // this is the normal trigger call
		$numfound:=qryFinishedGood($1; $2)
		If ($numfound>0)
			[Finished_Goods:26]THC_update_required:115:=True:C214
			SAVE RECORD:C53([Finished_Goods:26])
			REDUCE SELECTION:C351([Finished_Goods:26]; 0)
		End if 
		
	: ($1="init")
		expireAt:=1  //run until this var gets set to zero by a call with "die!" from the server
		$second:=60
		$delay:=60*60  //Check for quit every 60 seconds, revolution 15 minute intervals
		$interval:=15
		$revolution:=1
		Repeat 
			
			$numBH:=FG_Bill_and_Hold_Collection("init")  //init creates arrays that show inventory by jobit reduced by the amount that was billed and held
			
			QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]THC_update_required:115=True:C214)
			While (Not:C34(End selection:C36([Finished_Goods:26])))
				$error:=THC_calc_one_item([Finished_Goods:26]CustID:2; [Finished_Goods:26]ProductCode:1)
				If ($error=0)
					[Finished_Goods:26]THC_update_required:115:=False:C215
					SAVE RECORD:C53([Finished_Goods:26])
					utl_Logfile("thc.log"; "revolution "+String:C10($revolution; "00000")+" fg: "+[Finished_Goods:26]FG_KEY:47)
					
					JIC_Regenerate([Finished_Goods:26]FG_KEY:47)  // Modified by: Mel Bohince (5/8/14) 
					
				Else 
					utl_Logfile("thc.log"; "revolution "+String:C10($revolution; "00000")+" fg: "+[Finished_Goods:26]FG_KEY:47+" couldn't be calc'd ")
				End if 
				NEXT RECORD:C51([Finished_Goods:26])
				
			End while 
			
			$numBH:=FG_Bill_and_Hold_Collection("kill")
			
			$loop:=0
			While (expireAt>0) & ($loop<$interval)  //keep running 
				DELAY PROCESS:C323(Current process:C322; $delay)  // about ten times 30 seconds = appx 5 minutes
				$loop:=$loop+1
				//utl_Logfile ("thc.log";"    Loop "+String($loop))
			End while 
			
			$revolution:=$revolution+1
		Until (<>fQuit4D)
		
		
	: ($1="die!")  //called by On Server Shutdown
		$server_pid:=Process number:C372(process_name; *)
		If ($server_pid#0)
			SET PROCESS VARIABLE:C370($server_pid; expireAt; 0)
			DELAY PROCESS:C323($server_pid; 0)  //give the server a moment to start
		End if 
		utl_Logfile("server.log"; "THC_request_update (die!) pid = "+String:C10(server_pid)+" called.")
		
End case 





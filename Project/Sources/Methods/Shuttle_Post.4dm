//%attributes = {}
// -------
// Method: Shuttle_Post   ( ) ->
// By: Mel Bohince @ 06/07/17, 10:46:51
// Description
// save event objects to disk
// ----------------------------------------------------
C_TEXT:C284($1)
C_LONGINT:C283($minutes; $delay_in_seconds)
C_TIME:C306($docRef)

$hotFolder:=System folder:C487(Desktop:K41:16)
$hotFolder:=Replace string:C233($hotFolder; "Desktop"; "Dropbox")+"shuttle_inbox:"

$minutes:=5
$delay_in_seconds:=$minutes*60*60  //wake up every 15 minutes

READ WRITE:C146([ShuttleQ:174])


utl_Logfile("que_scheduler.log"; "Shuttle_Post launched"+", checking every "+String:C10($minutes)+" minutes.")

While (Not:C34(<>fQuit4D)) & (<>Shuttle_Publish_On)
	
	zwStatusMsg("Shuttle_Post"; "Checking for tasks")
	
	QUERY:C277([ShuttleQ:174]; [ShuttleQ:174]status:4#"SENT")
	$events:=Records in selection:C76([ShuttleQ:174])
	If ($events>0)
		
		ORDER BY:C49([ShuttleQ:174]; [ShuttleQ:174]created:7; >)
		utl_Logfile("que_scheduler.log"; String:C10($events)+" waiting")
		
		For ($i; 1; $events)
			//Stringify
			Case of 
				: ([ShuttleQ:174]entity_type:2="job")
					$json:=api_Jobs([ShuttleQ:174]fk_id:3)
					
				: ([ShuttleQ:174]entity_type:2="schedule")
					$json:=api_Schedule([ShuttleQ:174]fk_id:3)  //"cc[{seq1},{form2},...]"
					
				: ([ShuttleQ:174]entity_type:2="release")
					$json:=api_Releases([ShuttleQ:174]fk_id:3)
					
				: ([ShuttleQ:174]entity_type:2="milestone")
					$json:=api_Milestones([ShuttleQ:174]fk_id:3)
					
				Else 
					[ShuttleQ:174]status:4:="ERROR"
					SAVE RECORD:C53([ShuttleQ:174])
			End case 
			
			//save to hot folder
			If ([ShuttleQ:174]status:4#"ERROR")
				$docName:=[ShuttleQ:174]entity_type:2+"_"+[ShuttleQ:174]fk_id:3+"_"+fYYMMDD(4D_Current_date)+"_"+String:C10(Milliseconds:C459)+".json"
				$docRef:=Create document:C266($hotFolder+$docName)
				SEND PACKET:C103($docRef; $json)
				If (ok=1)
					[ShuttleQ:174]status:4:="SENT"
					[ShuttleQ:174]sent:6:=Substring:C12(String:C10(4D_Current_date; ISO date:K1:8); 1; 11)+String:C10(4d_Current_time; HH MM SS:K7:1)
					SAVE RECORD:C53([ShuttleQ:174])
					If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
						
						UNLOAD RECORD:C212([ShuttleQ:174])
						
						
					Else 
						
						// see line 77
						
						
					End if   // END 4D Professional Services : January 2019 
				End if 
				CLOSE DOCUMENT:C267($docRef)
			End if 
			
			NEXT RECORD:C51([ShuttleQ:174])
		End for 
		
	End if 
	
	REDUCE SELECTION:C351([ShuttleQ:174]; 0)
	
	zwStatusMsg("Shuttle_Post"; "Delaying for "+String:C10($minutes)+" minutes")
	DELAY PROCESS:C323(Current process:C322; $delay_in_seconds)  //take a nap
	
End while 
utl_Logfile("que_scheduler.log"; "ENDED")


//If (Count parameters=1)
//utl_Logfile ("que_scheduler.log";"Shuttle_Post rescheduled")
//$nextRun:=TSTimeStamp +(60*5)
//Que_AddToQueue ($nextRun;"Shuttle_Post";"client";"repeat")
//End if 


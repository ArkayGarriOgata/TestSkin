//%attributes = {}
//  // OBSOLETE_______
//  // OBSOLETE_______
//  // OBSOLETE_______
//  // OBSOLETE_______
//  // ----------------------------------------------------
//  // User name (OS): Mel Bohince
//  // Date and time: 02/20/20, 20:35:58
//  // ----------------------------------------------------
//  // Method: EDI_DESADV_aka_ASN
//  // Description
//  //daemon for sending advance ship notices

//C_TIME($runTime)
//C_DATE($firstDate)
//C_LONGINT($now_ts;$runAt_ts;$pid;<>EDI_ASN_pid)
//C_TEXT($1)
//C_BOOLEAN(<>EDI_ASN_keep_running;$testing;$NEW_ASN_MODE)
//$testing:=False  // TRUE to test the timing loop
//$NEW_ASN_MODE:=False  // TRUE is the DESADV "before" shipping rather than after, with TMC involvement

//If (User in group(Current user;"RoleSuperUser"))

//If (Count parameters=0)
//If (<>EDI_ASN_pid=0)  //fire this up
//<>EDI_ASN_pid:=New process("EDI_DESADV_aka_ASN";0;"EDI_DESADV_aka_ASN";"init")
//Else   //offer to kill
//CONFIRM("EDI_ASN is already running.";"Just Checking";"Kill")
//If (ok=0)
//<>EDI_ASN_keep_running:=False
//<>EDI_ASN_pid:=0
//End if 
//End if 

//Else   //here we go
//<>EDI_ASN_keep_running:=True
//  //run at specified time
//$runTime:=?06:40:00?  //this is when we want it to run
//$runDate:=Current date
//If (Not($testing))
//If (Current time>?09:00:00?)  //missed the time, wait until tomorrow, must have been a reboot
//$runDate:=$runDate+1
//End if 
//End if 


//$runAt_ts:=TSTimeStamp ($runDate;$runTime)  // in timestamp seconds
//utl_Logfile ("ASN.log";"First run at "+TS2iso ($runAt_ts))

//utl_Logfile ("ASN.log";"$NEW_ASN_MODE = "+String($NEW_ASN_MODE))
//utl_Logfile ("ASN.log";"$testing = "+String($testing))


//While ((Not(<>fQuit4D)) & ($runAt_ts>0) & (<>EDI_ASN_keep_running))

//Repeat   //keep checking the clock to see if its time to do the deed

//If (Not(<>fQuit4D)) & (<>EDI_ASN_keep_running)
//DELAY PROCESS(Current process;360)
//$now_ts:=TSTimeStamp 
//Else 
//$now_ts:=-1  //break
//End if 

//Until ($now_ts>$runAt_ts) | ($now_ts<0)  //its after the scheduled time


//If ($now_ts>0) & (<>EDI_ASN_keep_running)  //not break
//BEEP  //do it
//zwStatusMsg ("Run at";TS_ISO_String_TimeStamp )

//  //||||||||||||||||||||||||||||||||||||||||||`your code here
//utl_Logfile ("ASN.log";"Running...")

//If ($testing)
//BEEP
//DELAY PROCESS(Current process;180)

//Else 
//If ($NEW_ASN_MODE)  //only consider releases that were on the OPN report from TMC
//$pid:=New process("EDI_DESADV_get_PO_Calloffs";0;"Send ASN")
//If (False)
//EDI_DESADV_get_PO_Calloffs   //this one now sends the asn's
//End if 

//Else   //RFM mode, email generation, look for any qualifying release
//$pid:=New process("EDI_DESADV_get_Releases";0;"Send ASN")
//If (False)
//EDI_DESADV_get_Releases   //no longer sends asn's
//End if 
//End if 

//End if 

//utl_Logfile ("ASN.log";"Finished...")
//  //||||||||||||||||||||||||||||||||||||||||||`your code here

//If ($testing)
//$runTime:=Current time+(60*15)  //wait 15 minutes
//If ($runTime>?14:40:00?)  //reset for next day
//$runTime:=?06:20:00?
//$runDate:=$runDate+1
//End if 
//$runAt_ts:=TSTimeStamp ($runDate;$runTime)  //testing

//Else 
//$runDate:=$runDate+1  //reset date to tomorrow
//$runAt_ts:=TSTimeStamp ($runDate;$runTime)  //reset timestamp to tomorrow
//End if 

//utl_Logfile ("ASN.log";"Waiting until "+TS2iso ($runAt_ts))

//End if 

//End while   //not quitting 4D

//<>EDI_ASN_pid:=0
//<>EDI_ASN_keep_running:=False
//utl_Logfile ("ASN.log";"Shutdown ")
//End if 

//Else 
//BEEP
//End if   //superuser


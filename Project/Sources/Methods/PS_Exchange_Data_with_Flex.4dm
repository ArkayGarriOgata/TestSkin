//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 01/23/07, 09:30:29
// ----------------------------------------------------
// Method: PS_Exchange_Data_with_Flex()  --> 
// Description:
// Stored procedure to send and receive new data with flex
// ----------------------------------------------------
//If (Length(◊PATH_FLEX_INBOX)=0)  `this is temporary
//◊PATH_FLEX_INBOX:="Data_Collection:flex_inbox:"
//◊PATH_AMS_INBOX:="Data_Collection:ams_inbox:"
//End if 
// ----------------------------------------------------
//11/12/09 change to run on server or client, loss of datacollection volumn on server kills users

C_TEXT:C284($1)
C_LONGINT:C283(<>FLEX_EXCHG_PID; $delay; $loops)
C_BOOLEAN:C305(<>run_flex)

$delay:=30*60*60  //Check every 30 minutes // Modified by: Mark Zinke (6/3/13) Was 2 minutes

If (Count parameters:C259=0)
	<>FLEX_EXCHG_PID:=Process number:C372("PS_Exchange_Data_with_Flex")
	If (<>FLEX_EXCHG_PID=0)  //not already running
		<>run_flex:=True:C214
		//If (Application type=4D Server )  `(Application type#4D Client )
		<>FLEX_EXCHG_PID:=New process:C317("PS_Exchange_Data_with_Flex"; <>lMinMemPart; "PS_Exchange_Data_with_Flex"; "init")
		If (False:C215)
			PS_Exchange_Data_with_Flex
		End if 
		//End if 
	Else 
		uConfirm("PS_Exchange_Data_with_Flex is already running on this client."; "Just Checking"; "Kill")
		If (ok=0)
			<>run_flex:=False:C215
		End if 
	End if 
	
Else 
	utl_Logfile("PS_Exchange_Data_with_Flex.Log"; "STARTED")
	$loops:=0
	
	READ ONLY:C145([zz_control:1])
	ALL RECORDS:C47([zz_control:1])
	<>PATH_FLEX_INBOX:=[zz_control:1]ShopfloorPathOutbox:54
	<>PATH_AMS_INBOX:=[zz_control:1]TrelloBoardEmailAddress:55
	REDUCE SELECTION:C351([zz_control:1]; 0)
	
	If (Length:C16(<>PATH_FLEX_INBOX)>0)
		utl_Logfile("server.log"; "  Flex Send ON")
	End if 
	If (Length:C16(<>PATH_AMS_INBOX)>0)
		utl_Logfile("server.log"; "  Flex Receive ON")
	End if 
	
	//utl_Logfile ("server.log";"  Quit flag is set to: "+String(Num(◊fQuit4D)))
	
	While (Not:C34(<>fQuit4D)) & (<>run_flex)
		zwStatusMsg("X w/FLEX"; "Running...")
		
		$loops:=$loops+1
		//utl_Logfile ("PS_Exchange_Data_with_Flex.Log";"CHECKING INBOXES loop = "+String($loops))
		IDLE:C311
		If (Length:C16(<>PATH_FLEX_INBOX)>0)
			$send:=Batch_RunDate("Test"; "Flex-Work-to")
			If ($send>0)
				//utl_Logfile ("PS_Exchange_Data_with_Flex.Log";"Send at: "+TS2String ($send))
				PS_SaveAsText
				//User_NotifyAll 
			End if 
		End if 
		
		If (Length:C16(<>PATH_AMS_INBOX)>0)
			MT_import_data_collected
		End if 
		
		$tickle_server:=4D_Current_date
		zwStatusMsg("X w/FLEX"; "Pausing for "+String:C10($delay/(60*60))+" minutes at "+String:C10(Current time:C178; HH MM SS:K7:1))
		DELAY PROCESS:C323(Current process:C322; $delay)
		
		//provide a chance to change target folder
		//READ ONLY([zz_control])
		//ALL RECORDS([zz_control])
		//◊PATH_FLEX_INBOX:=[zz_control]ShopfloorPathOutbox
		//◊PATH_AMS_INBOX:=[zz_control]ShopfloorPathInbox
		//REDUCE SELECTION([zz_control];0)
		
		If (Length:C16(<>PATH_FLEX_INBOX)=0) & (Length:C16(<>PATH_AMS_INBOX)=0)
			utl_Logfile("PS_Exchange_Data_with_Flex.Log"; "*** INBOX PATHS ARE NOT SPECIFIED ***")
		End if 
		
	End while 
	<>FLEX_EXCHG_PID:=0
	utl_Logfile("PS_Exchange_Data_with_Flex.Log"; "ENDED loops:"+String:C10($loops))
End if 
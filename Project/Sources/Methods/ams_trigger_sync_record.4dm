//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 12/05/06, 16:35:00
// ----------------------------------------------------
// Method: ams_trigger_sync_record()  --> 
// Description
// wrapper to genroe sync
// ----------------------------------------------------
// Modified by Mel Bohince on 1/11/07 at 09:39:08 : deal with sync off condition
// ----------------------------------------------------

C_TEXT:C284($1)
C_LONGINT:C283($0)

$0:=0  //assume granted
//C_LONGINT($triggerLevel;$dbEvent;$tableNum;$recordNum)
//TRIGGER PROPERTIES(1;$dbEvent;$tableNum;$recordNum)

If (<>Sync_Activated)
	If (Count parameters:C259=1)
		//If (GNS_Sync ("InSyncProcess")#"True")
		EXECUTE FORMULA:C63($1)  //do normal trigger stuff
		//End if 
	End if 
	
	//C_LONGINT($mel_triggerLevel;$mel_dbEvent;$mel_ tableNum;$mel_recordNum)
	//TRIGGER PROPERTIES(Trigger level;$mel_dbEvent;$mel_ tableNum;$mel_recordNum)
	//utl_Logfile ("sync.log";"TRIGGER for level: "+String(Trigger level)+" event:"+String($mel_dbEvent)+" ["+Table name($mel_ tableNum)+"] recno:"+String($mel_recordNum))
	
	//GNS_Sync ("Trigger";"UpdateMode=Field;InsertMode=Field;SyncDelete=Yes")  `mode=Record;Field[Record]        SyncDelete=NO;Yes[Yes]
	
Else   // Modified by Mel Bohince on 1/11/07 at 09:39:08 : 
	If (Count parameters:C259=1)
		EXECUTE FORMULA:C63($1)  //do normal trigger stuff
	End if 
End if 
//ams_trigger_sync_record ("trigger_CustomersReleaseSchedul")
//Modifed by: Garri Ogata on 02/20/22 add ON ERR CALL to trap error messages so server doesn't hang with an alert.

C_TEXT:C284($1)
C_LONGINT:C283($0)
$0:=0  //assume granted
//C_LONGINT($triggerLevel;$dbEvent;$tableNum;$recordNum)
//TRIGGER PROPERTIES(1;$dbEvent;$tableNum;$recordNum)

e_OnTriggerError(CorektTriggerPre; Current method name:C684)

ON ERR CALL:C155("e_OnTriggerError")

If (<>Sync_Activated)
	
	//If (GNS_Sync ("InSyncProcess")#"True")
	$0:=trigger_CustomersReleaseSchedul
	//End if 
	
	//C_LONGINT($mel_triggerLevel;$mel_dbEvent;$mel_ tableNum;$mel_recordNum)
	//TRIGGER PROPERTIES(Trigger level;$mel_dbEvent;$mel_ tableNum;$mel_recordNum)
	//utl_Logfile ("sync.log";"TRIGGER for level: "+String(Trigger level)+" event:"+String($mel_dbEvent)+" ["+Table name($mel_ tableNum)+"] recno:"+String($mel_recordNum))
	
	//GNS_Sync ("Trigger";"UpdateMode=Field;InsertMode=Field;SyncDelete=Yes")  `mode=Record;Field[Record]        SyncDelete=NO;Yes[Yes]
	
Else   // Modified by Mel Bohince on 1/11/07 at 09:39:08 : 
	$0:=trigger_CustomersReleaseSchedul
End if 

e_OnTriggerError(CorektTriggerPost)

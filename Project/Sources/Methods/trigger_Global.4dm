//%attributes = {}
// Method: trigger_Global () -> 
// ----------------------------------------------------
// by: mel: 05/04/05, 16:19:55
// ----------------------------------------------------
// Description:
// Things to do to many tables
// ----------------------------------------------------

C_LONGINT:C283($0; $triggerLevel; $dbEvent; $tableNum; $recordNum)

$0:=0  //assume granted

TRIGGER PROPERTIES:C399(1; $dbEvent; $tableNum; $recordNum)

Case of 
	: (Trigger event:C369=On Deleting Record Event:K3:3)  //send to logfile
		//JTB_LogJTB ("DELETE";String($tableNum;"000")+" ~ "+Table name($tableNum)+" # "+String($recordNum))
		
		//: (Database event=On Saving Existing Record Event )  `send to logfile
		//JTB_LogJTB ("MODIFY";String($tableNum;"000")+" ~ "+Table name($tableNum)+" # "+String($recordNum))
End case 
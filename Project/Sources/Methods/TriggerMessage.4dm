//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 01/30/08, 10:11:37
// ----------------------------------------------------
// Method: TriggerMessage("action"{;message})->text:msg
// Description
// Prepare or teardown a trigger message record
// ----------------------------------------------------

C_TEXT:C284($1)
C_TEXT:C284($0; $2)

Case of 
	: ($1="load")
		READ WRITE:C146([z_TriggerMessage:148])
		SET QUERY LIMIT:C395(1)
		QUERY:C277([z_TriggerMessage:148]; [z_TriggerMessage:148]Record_in_Use:2=False:C215)
		SET QUERY LIMIT:C395(0)
		If (Records in selection:C76([z_TriggerMessage:148])=0) | (Locked:C147([z_TriggerMessage:148]))
			CREATE RECORD:C68([z_TriggerMessage:148])
			[z_TriggerMessage:148]Message:3:="ready"
			SAVE RECORD:C53([z_TriggerMessage:148])
		End if 
		
		[z_TriggerMessage:148]Record_in_Use:2:=True:C214
		[z_TriggerMessage:148]Message:3:=""
		SAVE RECORD:C53([z_TriggerMessage:148])
		$0:=[z_TriggerMessage:148]Message:3
		
	: ($1="tear-down")
		[z_TriggerMessage:148]Record_in_Use:2:=False:C215
		//[z_TriggerMessage]Message:=""
		SAVE RECORD:C53([z_TriggerMessage:148])
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
			
			UNLOAD RECORD:C212([z_TriggerMessage:148])
			REDUCE SELECTION:C351([z_TriggerMessage:148]; 0)
			
			
		Else 
			
			REDUCE SELECTION:C351([z_TriggerMessage:148]; 0)
			
			
		End if   // END 4D Professional Services : January 2019 
		$0:=""
		
	: ($1="set-message")  //see also TriggerMessage_Set
		TRACE:C157
		LOAD RECORD:C52([z_TriggerMessage:148])
		[z_TriggerMessage:148]Message:3:=TS2String(TSTimeStamp)+": "+$2+Char:C90(13)+[z_TriggerMessage:148]Message:3
		SAVE RECORD:C53([z_TriggerMessage:148])
		$0:=[z_TriggerMessage:148]Message:3
		
	: ($1="get-message")
		TRACE:C157
		LOAD RECORD:C52([z_TriggerMessage:148])
		$0:=[z_TriggerMessage:148]Message:3
End case 
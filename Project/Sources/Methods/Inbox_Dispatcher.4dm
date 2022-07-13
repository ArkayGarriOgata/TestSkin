//%attributes = {}
//Method: Inbox_Dispatcher(msg;param1;param2)  120498  MLB
// make a fascade to collect all the inbox calls in one place.

C_TEXT:C284($1; $msg)
C_LONGINT:C283($0)  //return 0 for success
C_TEXT:C284($2; $3)
C_POINTER:C301($4)

$0:=-1  //fail closed

If (Count parameters:C259>0)
	$msg:=$1
Else 
	$msg:="show"
End if 

Case of 
	: ($msg="Notify")
		DELAY PROCESS:C323(Current process:C322; 30)  //incase its initing itself
		
		If (Application type:C494#4D Server:K5:6)
			If (<>PID_inbox#0)
				POST OUTSIDE CALL:C329(<>PID_inbox)
			Else 
				Inbox_Dispatcher("Show")
			End if 
		End if 
		
	: ($msg="addBlob")
		If (Count parameters:C259=4)
			zBlobLoad($2; Num:C11($3); ""; $4)
		Else 
			zBlobLoad($2; Num:C11($3))
		End if 
		
	: ($msg="Map")
		QUERY:C277([edi_Inbox:154]; [edi_Inbox:154]Mapped:6=0)
		
		While ((Not:C34(Windows Alt down:C563)) & (Not:C34(End selection:C36([edi_Inbox:154]))))
			EDI_MapInboxMsg
			NEXT RECORD:C51([edi_Inbox:154])
		End while 
		
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
			
			UNLOAD RECORD:C212([edi_Inbox:154])
			
		Else 
			
			// you have next record on line 40
			
		End if   // END 4D Professional Services : January 2019 
		
		$0:=0
		
	: ($msg="Add")
		If (Count parameters:C259>=3)
			CREATE RECORD:C68([edi_Inbox:154])
			[edi_Inbox:154]ID:1:=Sequence number:C244([edi_Inbox:154])
			[edi_Inbox:154]Received:5:=TSTimeStamp
			[edi_Inbox:154]Path:2:=$2
			TEXT TO BLOB:C554($3; [edi_Inbox:154]Content:3; UTF8 text without length:K22:17)
			SAVE RECORD:C53([edi_Inbox:154])
			$0:=0
			
		Else   //usage error
			TRACE:C157
		End if 
		
	: ($msg="AddSessionBlob")
		If (Count parameters:C259=2)
			CREATE RECORD:C68([edi_Inbox:154])
			[edi_Inbox:154]ID:1:=Sequence number:C244([edi_Inbox:154])
			[edi_Inbox:154]ICN:4:="SESSION LOG"
			[edi_Inbox:154]Received:5:=TSTimeStamp
			[edi_Inbox:154]Date_Received:9:=Current date:C33
			[edi_Inbox:154]Path:2:=$2
			[edi_Inbox:154]Mapped:6:=TSTimeStamp
			TEXT TO BLOB:C554(com_SessionLog; [edi_Inbox:154]Content:3; UTF8 text without length:K22:17; *)
			//[edi_Inbox]Content:=xcom_SessionLog
			SAVE RECORD:C53([edi_Inbox:154])
			$0:=0
			
		Else   //usage error
			TRACE:C157
		End if 
		
	: ($msg="Show")
		<>PID_inbox:=ViewSetter(2; ->[edi_Inbox:154])
		
	Else   //catch other possibilities - set to modify for default
		<>PID_inbox:=ViewSetter(2; ->[edi_Inbox:154])
End case 
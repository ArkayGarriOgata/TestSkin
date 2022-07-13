Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		If ([edi_Inbox:154]WasRead:7)
			Core_ObjectSetColor("*"; "displaydetail@"; -(Black:K11:16+(256*Light grey:K11:13)))
		Else 
			Core_ObjectSetColor("*"; "displaydetail@"; -(Dark blue:K11:6+(256*White:K11:1)))
		End if 
		sDateTime:=TS2String([edi_Inbox:154]Received:5)
		
		//: (Form event=On Activate )
		//If (Records in selection([edi_Inbox])<Records in table([edi_Inbox]))
		//uConfirm ("Show All mail?";"All";"No")
		//If (ok=1)
		//ALL RECORDS([edi_Inbox])
		//ORDER BY([edi_Inbox];[edi_Inbox]Received;<)
		//End if 
		//End if 
		
	: (Form event code:C388=On Outside Call:K2:11)
		utl_Trace
		If (<>fQuit4D)
			CANCEL:C270
			bdone:=1
		Else 
			C_TEXT:C284($msg)
			
			$msg:="New Mail"
			
			Case of 
				: ($msg="New Mail")
					QUERY:C277([edi_Inbox:154]; [edi_Inbox:154]WasRead:7=False:C215)
					ORDER BY:C49([edi_Inbox:154]; [edi_Inbox:154]ID:1; <)
					SET WINDOW TITLE:C213(fNameWindow(Current form table:C627))
					SHOW PROCESS:C325(Current process:C322)
					BRING TO FRONT:C326(Current process:C322)
			End case 
		End if 
		
	: (Form event code:C388=On Close Box:K2:21)
		bDone:=1
		CANCEL:C270
		<>PID_inbox:=0
		
	: (Form event code:C388=On Unload:K2:2)
		bDone:=1
		<>PID_inbox:=0
End case 
//
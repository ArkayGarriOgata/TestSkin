//%attributes = {"publishedWeb":true}
//PM: ZebraTest() -> 
//@author mlb - 11/6/01  11:04
//open a ZPL II script in a document and send it to the printer

C_TIME:C306($docRef)
C_TEXT:C284(xText)

xText:=""

zwStatusMsg("ZEBRA"; "Open the document containing the test script")
$docRef:=Open document:C264("")
If (OK=1)
	RECEIVE PACKET:C104($docRef; xText; 32000)  //read the script
	CLOSE DOCUMENT:C267($docRef)
	
	utl_LogIt("init")
	utl_LogIt(xText; 0)
	utl_LogIt("show")
	utl_LogIt("init")
	CONFIRM:C162("Pick protocol."; "Serial"; "TCP/IP")
	If (OK=1)
		SET CHANNEL:C77(21; 29706)  //open a stream to the Zebra printer
		SEND PACKET:C103(xText)  //send the label
		
	Else 
		com_state:=-1
		$err:=TCP_Open("192.168.3.238"; 9100; com_controlStream; 0)  // open command stream, 30 sec timeout
		
		zwStatusMsg("COM"; "Starting Session: Open id: "+String:C10(com_controlStream)+" State: "+String:C10(com_state))
		$connectionState:=COM_WaitForState(com_controlStream; 8; 120)
		$reply:=COM_WaitForReply(com_controlStream)
		$reply:=COM_SendCmd(com_controlStream; xText)
	End if 
	xText:=""
Else 
	BEEP:C151
End if 
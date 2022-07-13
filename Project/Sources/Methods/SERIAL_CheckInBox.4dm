//%attributes = {}
// Method: SERIAL_CheckInBox (terminalNumber) -> next response msg
// ----------------------------------------------------
// by: mel: 01/24/05, 15:06:27
// ----------------------------------------------------
// Description:
// look for responses in the Inbox directed to channel "mailbox"
// send back to caller next message in queue and remove it from que
// ----------------------------------------------------

C_LONGINT:C283($1; $tomPosition; $tries)
C_TEXT:C284($TOM)  //"Termination Of Message"
C_TEXT:C284($0; $nextMsg)

$tries:=0
$TOM:=Char:C90(13)  //Terminal ends a response with a <CR>
$nextMsg:=""

While (Semaphore:C143("$ComInBoxBuzy"))
	IDLE:C311
	DELAY PROCESS:C323(Current process:C322; <>waitInterval+5)
	If ($tries>0)
		MESSAGE:C88("√")
	End if 
	$tries:=$tries+1
End while 

//find messages for "boxNumber" grab them and delete them
//or maybe just get htem one at a time
If (Length:C16(<>com_InBox{$1})>0)
	$tomPosition:=Position:C15($TOM; <>com_InBox{$1})
	
	If ($tomPosition>0)  //channel id already gone
		$nextMsg:=Substring:C12(<>com_InBox{$1}; 1; $tomPosition)  // keep the CR 
		<>com_InBox{$1}:=Substring:C12(<>com_InBox{$1}; $tomPosition+1)  //pop-off current msg
		
	Else   // whats there is incomplete, ?no, clear it?
		<>com_InBox{$1}:=""
	End if 
	
End if 

CLEAR SEMAPHORE:C144("$ComInBoxBuzy")

$0:=$nextMsg
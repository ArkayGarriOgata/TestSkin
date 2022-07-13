//%attributes = {}
// OBSOLETE Method: SERIAL_AddToInBox (mailbox number;text) -> 
// ----------------------------------------------------
// by: mel: 01/31/05, 16:04:50
// ----------------------------------------------------
// Description:
// append a message to the inbox for the next time 
// a terminal or base looks its messages.
// make sure the termination character is always added
//OBSOLETE
// ----------------------------------------------------

C_LONGINT:C283($1; $tries)  //mailbox number
C_TEXT:C284($2)
C_TEXT:C284($TOM)  //"Termination Of Message is a char(13)"

$tries:=0
$TOM:=<>cr

//get ready before grabbing the semaphore
$length:=Length:C16($2)
If ($length>0)
	If ($2[[$length]]=$TOM)  //already terminated
		$TOM:=""  // don't add it on at line 39
	End if 
End if 

If (True:C214)
	If (<>rft_TerminalLoggedIn{$1}#0)
		rft_inboxOfTerminal:=""
		rft_inbox:=""
		GET PROCESS VARIABLE:C371(<>rft_TerminalLoggedIn{$1}; rft_inbox; rft_inboxOfTerminal)
		If (Length:C16(rft_inboxOfTerminal)<2)  //if only one char, its garbage anyway
			SET PROCESS VARIABLE:C370(<>rft_TerminalLoggedIn{$1}; rft_inbox; $2+$TOM)  //stripoff terminal
			
		Else   //last message not processed yet
			MESSAGE:C88("••Waiting for terminal "+String:C10($1)+" mailbox to be cleared."+<>cr)
			DELAY PROCESS:C323(Current process:C322; <>waitInterval)
			com_buffer:=com_buffer+$nextMsg
		End if 
	End if 
	
Else 
	While (Semaphore:C143("$ComInBoxBuzy"))  //keep trying, don't lose the message
		IDLE:C311
		DELAY PROCESS:C323(Current process:C322; <>waitInterval)
		If ($tries>0)
			MESSAGE:C88("+")
		End if 
		$tries:=$tries+1
	End while 
	
	<>com_InBox{$1}:=$2+$TOM
	
	CLEAR SEMAPHORE:C144("$ComInBoxBuzy")
End if 
//%attributes = {}
//  ` Method: SERIAL_AddToOutBox (text) -> 
//  ` ----------------------------------------------------
//  ` by: mel: 01/24/05, 14:52:06
//  ` ----------------------------------------------------
//  ` Description:
//  ` add some text to the OutBox for next send
//  ` Updates:
//
//  ` ----------------------------------------------------
//
//C_TEXT($1;$msg)
//C_TEXT($EOT)
//$EOT:=Char(4)
//C_LONGINT($msgLength;$0;$tries)
//$tries:=0
//$msgLength:=Length($1)
//
//If ($msgLength>1)
//  `rft_logger ("<send<"+$1)
//
//If ($1≤$msgLength≥#$EOT)
//$msg:=$1+$EOT
//Else 
//$msg:=$1
//End if 
//
//While (Semaphore("$ComOutBoxBuzy"))
//IDLE
//DELAY PROCESS(Current process;◊waitInterval)
//If ($tries>0)
//  `rft_logger ("-")
//End if 
//$tries:=$tries+1
//End while 
//
//If (Length(◊com_OutBox+$1)<32000)
//◊com_OutBox:=◊com_OutBox+$msg
//Else   `overflow, maybe use blobs later 
//◊com_OutBox:=$msg
//  `rft_logger ("OutBox is full, old messages purged.")
//End if 
//
//CLEAR SEMAPHORE("$ComOutBoxBuzy")
//
//Else 
//$msgLength:=0
//End if   `empty msg
//
//$0:=$msgLength
//%attributes = {}
//  ` Method: SERIAL_Receive () -> 
//  ` ----------------------------------------------------
//  ` by: mel: 02/09/05, 19:26:59
//  ` ----------------------------------------------------
//  ` Description:
//  `Grab anything in the serial buffer, then if it is addressed to a terminal or 
//  `base, try to poke it into their inbox variable, if that inbox is empty. If its not
//  `empty, go to the next message in the buffer and put this one in the back of the 
//  `queue.
//  ` ----------------------------------------------------
//C_LONGINT($0;$bytes;$endOfMsg;$err)
//C_TEXT($nextMsg;$now)  `$now:=String(4d_Current_time;HH MM SS )+" "
//C_BOOLEAN($delivered)
//
//If (SerialPluginInUse)
//  `$err:=GNX_STKX_Receive (com_portRef;com_buffer)
//Else 
//RECEIVE BUFFER(com_buffer)
//$err:=Num(Not(ok=1))
//End if 
//
//If ($err>=0)
//$bytes:=Length(com_buffer)
//Case of 
//: ($bytes>1)
//If ($bytes=3)  `this is most likely a command string or a menu pick
//rft_logger (com_buffer≤1≥+" "+String(Ascii(com_buffer≤2≥);"000")+" "+String(Ascii(com_buffer≤3≥);"000"))
//Else   `it is a payload
//rft_logger (">Received> "+com_buffer)
//End if 
//
//$endOfMsg:=Position(◊cr;com_buffer)
//While ($endOfMsg>0) & (◊COM_SerialPortActive)  `its at least one character, possible a message
//$nextMsg:=Substring(com_buffer;1;$endOfMsg)  ` keep the CR
//  `rft_logger (":::Trying to mail "+$nextMsg)
//com_buffer:=Substring(com_buffer;$endOfMsg+1)  `pop-off current msg
//  `determine if this is a viable message that has a destination
//$terminalID:=$nextMsg≤1≥
//$mailBox:=Find in array(◊rft_terminalIDs;$terminalID)  `$mailBox is used to ref internally here
//
//If ($mailBox>-1)  `try to deliver
//Case of 
//: (◊rft_TerminalLoggedIn{$mailBox}=0)  `tell base to fire that sucker up
//rft_logger ("!!!!Sign on "+$terminalID)
//$delivered:=rft_PortableAddToInBox (0;$nextMsg;True)  `repeat until successful
//
//: (◊rft_TerminalLoggedIn{$mailBox}#0)  `terminal is running, try to send a message
//If (Not(rft_PortableAddToInBox ($mailBox;Substring($nextMsg;2);False)))
//rft_logger ("••Waiting for terminal "+$terminalID+" mailbox to be cleared.")
//com_buffer:=com_buffer+$nextMsg  `try again later, put it at the end of the que
//$delivered:=rft_PortableAddToInBox (0;$nextMsg;False)  `let the base test for erros
//End if 
//
//Else 
//rft_logger ("••Terminal mailbox "+String($mailBox)+" is not available yet, will try again.")
//DELAY PROCESS(Current process;◊waitInterval)
//com_buffer:=com_buffer+$nextMsg  `try again later, put it at the end of the que`send to base unit to launch terminal
//End case 
//
//Else 
//rft_logger ("••Mailbox "+String($mailBox)+" is unknown, ignoring, this bytes")
//End if   `viable msg
//
//$endOfMsg:=Position(◊cr;com_buffer)  `check if there is another message
//End while 
//
//: ($bytes=1)
//rft_logger ("••1 char received, ignoring the "+String(Ascii(com_buffer);"000"))  `could be garbage sent by base trying to snyc up with the serial port
//End case 
//
//Else 
//rft_logger ("••Serial port receive err: "+String($err)+". May need to restart.")
//$bytes:=0
//End if 
//
//com_buffer:=""  `make sure any garbage is cleared
//$0:=$bytes
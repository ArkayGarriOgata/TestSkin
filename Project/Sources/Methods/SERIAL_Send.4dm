//%attributes = {}
//  ` Method: SERIAL_Send () -> 
//  ` ----------------------------------------------------
//  ` by: mel: 01/24/05, 14:03:17
//  ` ----------------------------------------------------
//  ` Description:
//  ` send waiting data, if blocked for more than
//  `$semaphoreTimeOut, then try later.
//
//  ` ----------------------------------------------------
//C_LONGINT($semaphoreTimeOut;$0;$err)
//$semaphoreTimeOut:=60  `1 second per try
//$0:=0
//  `try to send, or wait till later
//If (Not(Semaphore("$ComOutBoxBuzy";$semaphoreTimeOut))) & (◊COM_SerialPortActive)
//  `
//$0:=Length(◊com_OutBox)
//If ($0>0)
//  `rft_logger (" <Send< "+◊com_OutBox)
//If (SerialPluginInUse)
//  `$err:=GNX_STKX_Send (com_portRef;◊com_OutBox)
//Else 
//SEND PACKET(◊com_OutBox)
//$err:=Num(Not(ok=1))
//End if 
//  `rft_logger (" <Sent< "+◊com_OutBox)
//
//If ($err=0)
//◊com_OutBox:=""
//Else 
//BEEP
//ALERT("Send to Serial port failed. Restart aMs Client."+String($err))
//End if 
//
//End if 
//
//CLEAR SEMAPHORE("$ComOutBoxBuzy")
//Else 
//$now:=String(4d_Current_time;HH MM SS )+" "
//MESSAGE($now+"bs")
//End if 
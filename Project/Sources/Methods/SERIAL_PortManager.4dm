//%attributes = {}
//  ` Method: SERIAL_PortManager () -> 
//  ` ----------------------------------------------------
//  ` by: mel: 01/31/05, 14:51:30
//  ` ----------------------------------------------------
//  ` Description:
//  ` take care of communications thru the serial point
//  ` open a connection to a serial port and manage sends and receives
//  ` using COM_InBox and COM_OutBox which are both protected by semaphores 
//
//  ` ----------------------------------------------------
//C_LONGINT($1;$got;$sent;$err;$semaphoreTimeOut)
//$err:=SERIAL_PortInit ($1)
//
//If ($err=0)
//$semaphoreTimeOut:=180  `3 seconds
//$SerialPortInUse:="$SP"+String(com_portRef)
//If (Not((Semaphore($SerialPortInUse;$semaphoreTimeOut))))
//◊COM_SerialPortActive:=True
//
//While (◊COM_SerialPortActive)  `until told to quit
//DELAY PROCESS(Current process;◊waitInterval)  `don't spin to fast
//$got:=SERIAL_Receive   `$got:=SERIAL_Get 
//IDLE
//$sent:=SERIAL_Send   `that which was added with serial_AddToOutBox
//End while   ` listening
//
//CLEAR SEMAPHORE($SerialPortInUse)
//
//End if 
//
//Else 
//BEEP
//ALERT("Error "+String($err)+" trying to establish serial connection. Try re-booting.")
//End if   `serial port specified
//
//$err:=SERIAL_PortInit   `finally, cleanup
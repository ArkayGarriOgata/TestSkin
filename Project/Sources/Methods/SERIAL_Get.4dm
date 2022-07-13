//%attributes = {}
// Method: SERIAL_Get () -> ••• replaced by SERIAL_Receive
// ----------------------------------------------------
// by: mel: 01/24/05, 14:04:44
// ----------------------------------------------------
// Description:
// receive  waiting data, if blocked for more than
//$semaphoreTimeOut, then try later.
// ----------------------------------------------------

C_LONGINT:C283($semaphoreTimeOut; $0; $err)
C_TEXT:C284($now)

$semaphoreTimeOut:=120  //2 seconds
$now:=String:C10(4d_Current_time; HH MM SS:K7:1)+" "
$0:=0

If (Not:C34(Semaphore:C143("$ComInBoxBuzy"; $semaphoreTimeOut))) & (<>COM_SerialPortActive)
	If (SerialPluginInUse)
		//$err:=GNX_STKX_Receive (com_portRef;com_buffer)
	Else 
		RECEIVE BUFFER:C172(com_buffer)
		$err:=Num:C11(Not:C34(ok=1))
	End if 
	
	//If ($err=0)
	$0:=Length:C16(com_buffer)
	If ($0>0)
		//MESSAGE(TS2String (TSTimeStamp )+Char(13)+">Received> "+com_buffer)
		MESSAGE:C88($now+">Received> "+com_buffer+Char:C90(13))
		//If ($0<5)
		//For ($char;1;$0)
		//MESSAGE(String(Ascii(com_buffer≤$char≥);"000")+" ")
		//End for 
		//End if 
		//MESSAGE(Char(13))
		<>com_InBox{0}:=<>com_InBox{0}+com_buffer
		com_buffer:=""
	End if 
	
	//Else 
	//BEEP
	//ALERT("Receive from Serial port failed. Restart aMs Client."+String($err))
	//End if   `err
	
	CLEAR SEMAPHORE:C144("$ComInBoxBuzy")
Else 
	MESSAGE:C88("bc")
End if 
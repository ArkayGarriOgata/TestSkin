//%attributes = {}
// Method: SERIAL_PortInit () -> 
// ----------------------------------------------------
// by: mel: 02/09/05, 20:50:08
// ----------------------------------------------------
// Description:
// 
// Updates:
// • mel (4/21/05, 11:44:42) hint about esc to quit
// ----------------------------------------------------
//C_LONGINT($NumberOfTerminals)
//$NumberOfTerminals:=$1  `could be up to 64

If (Count parameters:C259=1)
	C_BOOLEAN:C305(<>COM_SerialPortActive; SerialPluginInUse)
	C_LONGINT:C283(SerialLogWinRef; $err; com_port; com_portSettings; com_portRef; $portIndex; $portCount)
	C_TEXT:C284(<>com_OutBox; com_portPath; com_buffer; rft_inboxOfTerminal; rft_inbox)  // see SERIAL_AddToOutBox
	ARRAY TEXT:C222(<>com_InBox; 0)
	
	SerialPluginInUse:=False:C215
	//ARRAY TEXT(◊com_InBox;$NumberOfTerminals)  `see SERIAL_CheckInBox
	//◊com_InBox{0}:=""  `"READY"
	
	SET MENU BAR:C67(<>DefaultMenu)
	
	SerialLogWinRef:=Open window:C153(5; 45; 1000; 355; 8; "Serial Port Log, press <esc> to Quit")
	
	MESSAGE:C88("::WAITING FOR SERIAL PORT::"+<>cr)
	MESSAGE:C88("::HOST WAITING FOR MESSAGES::"+<>cr)
	
	If (SerialPluginInUse)  //native 4D2003 can't find USB adapted Serial Port
		MESSAGE:C88("::  Using STKX plugin"+Char:C90(13))
		//$err:=GNX_STKX_Init ("";"DEMO";"";"")
		//$err:=GNX_STKX_CountPorts ($portCount;kSX_AllSerialPorts)  `kSX_AllSerialPorts is a constant in the plugin
		com_port:=-1
		com_portPath:=""
		com_portRef:=-1
		For ($portIndex; 1; $portCount)
			//$err:=GNX_STKX_GetIndPort ($portIndex;$portName;$devicePath)
			//CONFIRM($devicePath+"//"+$portName)`if(ok=1)`selected this channel 
			//tested with IOGear USB2Serial adaptor and driver found in PL2303x_1.0.7b4.pkg
			If (Position:C15("usbserial"; $portName)>0)
				com_port:=$portIndex
				com_portPath:=$devicePath
				$portIndex:=1+$portCount  //break
			End if 
		End for 
		
		//$err:=GNX_STKX_OpenDevicePath (com_portPath;com_portRef)
		//If (False)
		//defaults seem fine
		//$err:=GNX_STKX_GetParameters (com_portRef;baud;bits;parity;stops;handshake)
		
		//setting them thru an error
		//$err:=GNX_STKX_SetParameters (com_portRef;kSX_B9600;kSX_DataBits8;kSX_ParityNone;kSX_StopBits1;kSX_Handshake_None)
		
		//timeout is 1, seems fine to me
		//$err:=GNX_STKX_GetTimeout (com_portRef;com_time_out)
		//End if 
		
	Else   //this works on a PC with normal serial port, probably ok on legacy Mac too.
		MESSAGE:C88("::  Using native 4D"+Char:C90(13))
		ARRAY LONGINT:C221($aPortNumbers; 0)
		ARRAY TEXT:C222($aPortNames; 0)
		GET SERIAL PORT MAPPING:C909($aPortNumbers; $aPortNames)
		$portNumber:=Find in array:C230($aPortNames; "usbserial")
		If ($portNumber>0)
			com_port:=$portNumber+100
		Else 
			com_port:=1  //works on my Dell, PC Com port 1
		End if 
		
		com_portPath:="not used"
		com_portSettings:=Speed 9600:K31:13+Data bits 8:K31:23+Parity none:K31:17+Protocol none:K31:16+Stop bits one:K31:24
		SET CHANNEL:C77(com_port; com_portSettings)
		$err:=Num:C11(Not:C34(ok=1))
		com_portRef:=com_port+com_portSettings
		//Else   `testing by writing to a file
		//SET CHANNEL(com_portSettings;"scanner.txt")
	End if 
	
Else   //destruct
	MESSAGE:C88("::CLOSING SERIAL CONNECTION::"+Char:C90(13))
	If (Length:C16(<>com_OutBox)>0)
		ALERT:C41(<>com_OutBox; "Not Sent")
	End if 
	<>com_OutBox:=""  //clear any pending messages
	If (SerialPluginInUse)
		//$err:=GNX_STKX_Close (com_portRef)
	Else 
		SET CHANNEL:C77(11)
	End if 
	
	<>COM_SerialPort_PID:=0
	<>COM_SerialPortActive:=False:C215
	CLOSE WINDOW:C154(SerialLogWinRef)
End if 

$0:=$err
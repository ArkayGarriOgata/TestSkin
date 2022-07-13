//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 11/17/05, 13:25:42
// ----------------------------------------------------
// Method: Zebra_PrintPalletLabel
// Description
// 
//
// Parameters
// ----------------------------------------------------
C_LONGINT:C283($error)
C_TEXT:C284($buffer)
$error:=TCP_Open(tcpAddress; tcpPort; tcpID; 0)  //Synchronous
If ($error=0)
	$buffer:=Zebra_Style_FG_Pallet
	$error:=TCP_Send(tcpID; $buffer)
	If ($error=0)
		$buffer:=Zebra_Print_FG_Pallet
		$error:=TCP_Send(tcpID; $buffer)
		If ($error#0)
			ALERT:C41("Error: "+String:C10($error)+" on TCP_Send to Zebra "+tcpAddress+":"+String:C10(tcpPort))
		End if 
	Else 
		ALERT:C41("Error: "+String:C10($error)+" on TCP_Send to Zebra "+tcpAddress+":"+String:C10(tcpPort))
	End if 
Else 
	ALERT:C41("Error: "+String:C10($error)+" on TCP_Open to Zebra "+tcpAddress+":"+String:C10(tcpPort))
End if 
$error:=TCP_Close(tcpID)
If ($error#0)
	ALERT:C41("Error: "+String:C10($error)+" on TCP_Close")
End if 
//%attributes = {}
// Method: Zebra_testIP () -> 
// ----------------------------------------------------
// by: mel: 01/27/04, 14:46:33
// ----------------------------------------------------
// Description:
// 
// Updates:

// ----------------------------------------------------
C_LONGINT:C283($port; $error; $mode; $state)
C_LONGINT:C283($tcp_ID)
C_TEXT:C284($ipAddress; $buffer)
$ipAddress:="192.168.3.238"
$ipAddress:=Request:C163("IP Address of Printer:"; $ipAddress)
$port:=9100
$port:=Num:C11(Request:C163("IP Address of Printer:"; String:C10($port)))
$mode:=0
$testLabel:=""
$testLabel:=$testLabel+"^XA"+Char:C90(13)
$testLabel:=$testLabel+"^FO100,100"+Char:C90(13)
$testLabel:=$testLabel+"^CF0,55^FDZebra Technologies^FS"+Char:C90(13)
$testLabel:=$testLabel+"^XZ"+Char:C90(13)

$error:=TCP_Open($ipAddress; $port; $tcp_ID; $mode)
$error:=TCP_Send($tcp_ID; $testLabel)

//state seems to stay at 8
//Repeat 
//$error:=TCP_Receive ($tcp_ID;$buffer)
//$error:=TCP_State ($tcp_ID;$state)
//Until (($state=0) | ($error#0))

$error:=TCP_Close($tcp_ID)

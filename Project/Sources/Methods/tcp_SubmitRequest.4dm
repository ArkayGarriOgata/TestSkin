//%attributes = {"publishedWeb":true}
//PM: tcp_SubmitRequest(host;port;request;headers) -> $result
//@author mlb - 4/27/01  22:03
//ex params: 
//     host:="iwin.nws.noaa.gov"
//     port:=80 
//     request:="GET /iwin/ny/state.html HTTP/1.0"
//     headers:=""  `could be a If-Modified-Since...

C_TEXT:C284($1; $3; $requestLine; $4; $requestHeader; $0; $result; $buffer)
C_LONGINT:C283($err; $socket; $2; $port)
$host:=$1
$port:=$2
$requestLine:=$3
$requestHeader:=$4
$result:=""
$0:=$result

C_TEXT:C284($CRLF)
$CRLF:=Char:C90(13)+Char:C90(10)
C_LONGINT:C283($state; $RESET; $CLOSED; $LISTENING; $ESTABLISHED)
$CLOSED:=0
$RESET:=0
$LISTENING:=2
$ESTABLISHED:=8
$state:=$CLOSED
$buffer:=""

$err:=TCP_Open($host; $port; $socket)
If ($err=0)
	$err:=tcp_interrupt(10)
	Repeat 
		$err:=TCP_State($socket; $state)
		$err:=tcp_interrupt
	Until ($state=$ESTABLISHED) | ($err#0)
	
	$state:=$RESET
	$err:=TCP_Send($socket; $requestLine+$CRLF+$requestHeader+$CRLF+$CRLF)  //double CRLF ends the header section
	If ($err=0)
		$err:=TCP_State($socket; $state)
		
		$state:=$RESET
		$err:=tcp_interrupt(10)
		Repeat 
			$err:=TCP_Receive($socket; $buffer)
			$result:=$result+$buffer
			$err:=TCP_State($socket; $state)
			$err:=tcp_interrupt
		Until ($state=$CLOSED) | ($err#0)
		
		$err:=TCP_Close($socket)
		If ($err#0)
			$result:=$result+Char:C90(13)+"TCP_Close("+String:C10($socket)+") failed with an error#"+String:C10($err)+" "+IT_ErrorText($err)
		End if 
		
	Else 
		$result:="TCP_Send ("+String:C10($socket)+";"+$requestLine+") failed with an error#"+String:C10($err)+" "+IT_ErrorText($err)
	End if 
	
Else 
	$result:="TCP_Open ("+$host+";"+String:C10($port)+";$socket) failed with an error# "+String:C10($err)+" "+IT_ErrorText($err)
End if 

$0:=$result
//*****
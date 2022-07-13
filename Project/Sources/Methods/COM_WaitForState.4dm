//%attributes = {}
//tcpWaitForState(tcpSessionid;stateDesired;timeoutInTicks)->final state

C_LONGINT:C283($1; $2; $3; $0; $limit; $elapse; $connectionState)

$limit:=$3
$elapse:=0

Repeat 
	$err:=TCP_State($1; com_state)
	If ($elapse>0)
		DELAY PROCESS:C323(Current process:C322; 10)
		BEEP:C151
		IDLE:C311
		$elapse:=$elapse+10
	Else 
		$elapse:=$elapse+1
	End if 
Until (com_state=$2) | ($elapse>$limit)

$0:=com_state
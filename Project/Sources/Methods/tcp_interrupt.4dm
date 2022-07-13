//%attributes = {"publishedWeb":true}
//PM: tcp_interrupt() ->
//@author mlb - 4/27/01  23:13
C_LONGINT:C283($1; $0; tcp_maxTrys; tcp_trys)
If (Count parameters:C259=1)
	tcp_maxTrys:=$1
	tcp_trys:=0
Else 
	tcp_trys:=tcp_trys+1
	If (tcp_trys>=tcp_maxTrys)
		$0:=tcp_maxTrys
	Else 
		IDLE:C311
		DELAY PROCESS:C323(Current process:C322; 3)
		$0:=0
	End if 
End if 
//******
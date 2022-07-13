//%attributes = {}
//Method: tcp_Sendit(streamid;text;options)  102398  MLB
//send character out a steam
C_LONGINT:C283($1; $0)
C_TEXT:C284($2)

$0:=TCP_Send($1; $2)

C_TEXT:C284($time)
$time:=Substring:C12(String:C10(Current time:C178; HH MM SS:K7:1); 4; 5)
If (Position:C15(com_password; $2)=0)
	com_SessionLog:=com_SessionLog+$time+" send->"+$2+Char:C90(13)
Else 
	com_SessionLog:=com_SessionLog+$time+"send->PASS ••••••••"+Char:C90(13)
End if 

C_BOOLEAN:C305(com_Trace)
If (com_Trace)
	If (Length:C16($2)>0)
		MESSAGE:C88("send->"+$2+"!"+Char:C90(13))
	End if 
End if 
//





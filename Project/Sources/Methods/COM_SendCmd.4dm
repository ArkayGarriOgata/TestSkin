//%attributes = {}
//COM_SendCmd(sessionid;mess)-.reply number

C_LONGINT:C283($1; $0)
C_TEXT:C284($2)

$err:=tcp_Sendit($1; $2)
$0:=COM_WaitForReply($1)
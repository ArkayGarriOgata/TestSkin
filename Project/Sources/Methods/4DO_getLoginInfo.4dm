//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 10/10/06, 11:23:10
// ----------------------------------------------------
// Method: 4DO_getLoginInfo
// ----------------------------------------------------

C_TEXT:C284($1)
C_BOOLEAN:C305($0)

$0:=False:C215

<>NetworkComponent:=29  //[CONTROL]API_NetworkComponent
<>sServName:=""

Case of 
	: ($1="Accounting")
		If (Records in selection:C76([zz_control:1])=0)
			READ ONLY:C145([zz_control:1])
			ALL RECORDS:C47([zz_control:1])
		End if 
		
		If (Length:C16([zz_control:1]API_TCPaddress:32)#0)
			<>sServName:=[zz_control:1]API_TCPaddress:32+","+[zz_control:1]API_PortNumber:22+":"+[zz_control:1]API_ServerName:17+Char:C90(9)+[zz_control:1]API_ComputerName:23
		Else 
			<>sServName:=[zz_control:1]API_ServerName:17
		End if 
		
		<>sUserName:=[zz_control:1]API_UserName:18
		<>sUserPswd:=[zz_control:1]API_UserPswd:19
		<>sTaskName:=[zz_control:1]API_TaskName:20
		<>fSendInv:=[zz_control:1]API_SendInvos:21
		$0:=(Length:C16(<>sServName)>0)
		
	Else 
		uConfirm("'"+$1+"' has not been set up in 4DO_getLoginInfo."; "OK"; "Help")
End case 
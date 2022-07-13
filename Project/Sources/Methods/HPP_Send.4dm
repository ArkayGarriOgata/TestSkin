//%attributes = {}
// Method: HPP_Send () -> 
// ----------------------------------------------------
// by: mel: 01/17/05, 15:20:51
// ----------------------------------------------------
// Description:
//The format for a Host Command is:
//  <SYN>NS@,HCMD$0<CR>
//   where $ is the command, see page 3-5 in Versacode manual
// case statement used to translate host commands to something a little more readable
// ----------------------------------------------------

C_TEXT:C284($1; $2; $response)
C_LONGINT:C283($0)

zwStatusMsg("Send: "; $1)

Case of   //translation of host commands to something a little more readable
	: ($1="beep")
		BEEP:C151
		hpp_hostCommand:="BEP"
		
	: ($1="good")
		hpp_hostCommand:="IGS"
		
	: ($1="bad")
		hpp_hostCommand:="IBS"
		
	: ($1="prompt")
		If (Length:C16($2)>0)
			hpp_hostCommand:="OUTS("+util_Quote($2)+")"
			hpp_lastPrompt:=$2
			MESSAGE:C88("HOST-->"+"N"+hhp_scannerID+",HCMD"+hpp_hostCommand+Char:C90(13))
		Else 
			BEEP:C151
			zwStatusMsg("Send"; "Prompt string was empty.")
		End if 
		
	: ($1="get")
		hpp_hostCommand:="INS()"
		
	: ($1="check")
		hpp_hostCommand:="SCNID"
		
	: ($1="scanners?")
		hpp_hostCommand:="JOINEDSCANNERS"
		
	Else 
		hpp_hostCommand:=""
		
End case 

//MESSAGE("HOST-->"+"N"+hhp_scannerID+",HCMD"+hpp_hostCommand+Char(13))
//ALERT("hpp send") `  <SYN>NS@,HCMD$0<CR>
If (Length:C16(hpp_hostCommand)>0)
	SEND PACKET:C103(Char:C90(22)+"N"+hhp_scannerID+",HCMD"+hpp_hostCommand+Char:C90(13))
	hpp_errorCode:=HPP_Get
Else 
	hpp_errorCode:=-20004
	hpp_errorSource:=$1+" was not understood."
End if 

$0:=hpp_errorCode
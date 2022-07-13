//%attributes = {}
// Method: HPP_Get () -> 
// ----------------------------------------------------
// by: mel: 01/18/05, 11:42:19
// ----------------------------------------------------

C_LONGINT:C283($arguments; $delim)

$delim:=Character code:C91(",")

If (hpp_portSettings#10)
	RECEIVE PACKET:C104(hpp_response; Char:C90(13))
Else   //testing to a file, use fake response
	Case of 
		: (Position:C15(hpp_hostCommand; " BEP IGS IBS SCNID")>0)  //just acknowledge
			hpp_response:=hhp_scannerID+",1,1,1"
		: (Position:C15(hpp_hostCommand; " JOINEDSCANNERS")>0)  //make up some scanner ids
			hpp_response:=hhp_scannerID+",2,4,SCN1,4,SCN2"
		: (Substring:C12(hpp_hostCommand; 1; 3)="OUT")  //just acknowledge a prompt was issued
			hpp_response:=hhp_scannerID+",1,1,1"
		Else   //make up an InputString
			//hpp_response:="1082123010154321371200"  `appcode+lot+case#+appcode+qty
			hpp_response:=hhp_scannerID+",3,1,1,4,k]Z0,22,"+Request:C163(hpp_lastPrompt)
	End case 
	SEND PACKET:C103("---->"+hpp_response+Char:C90(13))
End if 

MESSAGE:C88("SCANNER<<<"+hpp_response+Char:C90(13))
//ALERT("hpp get")
util_TextParser(10; hpp_response; $delim; $delim)

Case of 
	: (util_TextParser(1)#hhp_scannerID)
		hpp_errorCode:=-20003
		hpp_errorSource:="Scanner Id "+util_TextParser(1)+" was received."
	: (Num:C11(util_TextParser(2))<0)
		hpp_errorCode:=Num:C11(util_TextParser(2))
		hpp_errorSource:="HPP Error, see manual."
	Else 
		$arguments:=Num:C11(util_TextParser(2))
		hpp_value:=util_TextParser(2+($arguments*2))  //get the last of the pairs
		hpp_errorCode:=0
		hpp_errorSource:=""
End case 

$0:=hpp_errorCode

If (hpp_errorCode<0)
	HPP_ErrorMsg(hpp_errorCode)
End if 
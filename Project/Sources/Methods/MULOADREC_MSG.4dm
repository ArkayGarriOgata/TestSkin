//%attributes = {}

// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 12/07/15, 11:08:08
// ----------------------------------------------------
// Method: MULOADREC_MSG
// Description
// 
//
// Parameters
// ----------------------------------------------------



C_BOOLEAN:C305($0)  //$0:=True if record was deleted
C_POINTER:C301($1)  //$1=»file of locked record
C_LONGINT:C283($xlPID)
C_TEXT:C284($t3User; $t3Machine; $t3Process)

LOCKED BY:C353($1->; $xlPID; $t3User; $t3Machine; $t3Process)

$0:=($xlPID#-1)
If ($0)
	If (Length:C16($t3User)=0)
		$t3User:="You"
		$t3Machine:="Your"
		If ($xlPID=0)  //v1.5.6-SDG-added
			$t3Process:="This process (READ ONLY file)"  //v1.5.6-SDG-added
		End if   //v1.5.6-SDG-added
	End if 
	GOTO XY:C161(4; 1)
	MESSAGE:C88("The record in file "+Table name:C256($1)+" is in use, Please Wait…")
	GOTO XY:C161(3; 3)
	MESSAGE:C88("-"*52)
	GOTO XY:C161(4; 5)
	MESSAGE:C88("User: "+$t3User)
	GOTO XY:C161(4; 7)
	MESSAGE:C88("Process: "+$t3Process)
	GOTO XY:C161(4; 9)
	MESSAGE:C88("Computer: "+$t3Machine)
End if 
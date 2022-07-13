//%attributes = {}
// Method: util_UserValidation ({pin}) -> true if knows pin
// ----------------------------------------------------
// by: mel: 11/02/04, 15:05:30
// ----------------------------------------------------
// Description:
// see if person at the key board knows the logged in user's PIN

C_LONGINT:C283($hits)
C_TEXT:C284($pin; $1)
C_BOOLEAN:C305($0)
$0:=False:C215

If (Count parameters:C259>=1)
	$pin:=$1
	ok:=1
Else 
	$pin:=Request:C163("Please enter your P.I.N.:"; ""; "Enter"; "Cancel")
End if 

If (ok=1)
	//If (Length($pin)>0)
	SET QUERY DESTINATION:C396(Into variable:K19:4; $hits)
	QUERY:C277([Users:5]; [Users:5]UserName:11=Current user:C182; *)
	QUERY:C277([Users:5];  & ; [Users:5]PIN:16=$pin)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	If ($hits>0)
		$0:=True:C214
		<>PIN:=$pin
		<>lastPINentry:=Current time:C178-1  //reset the timer
	Else 
		<>PIN:=""
		<>lastPINentry:=0  //reset the timer
	End if 
	//End if 
End if 

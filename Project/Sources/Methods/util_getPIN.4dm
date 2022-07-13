//%attributes = {"publishedWeb":true}
//util_getPIN
C_BOOLEAN:C305($0)
$0:=False:C215
C_TEXT:C284($pin)
If (Current user:C182="Designer")
	$0:=True:C214
	zwStatusMsg("AUTHORIZE"; "PIN Accepted")
Else 
	zwStatusMsg("AUTHORIZE"; "Enter PIN")
	$pin:=Substring:C12(Request:C163("Enter PIN then click OK:"; ""; "OK"; "Cancel"); 1; 4)
	If (ok=1)
		If ($pin="ws")
			$0:=True:C214
			zwStatusMsg("AUTHORIZE"; "PIN Accepted")
		Else 
			zwStatusMsg("AUTHORIZE"; "Incorrect PIN")
		End if 
	End if 
End if 
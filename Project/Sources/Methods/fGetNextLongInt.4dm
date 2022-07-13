//%attributes = {"publishedWeb":true}
//Key No:=fGetNextLongInt(»[File])
C_POINTER:C301($1)
C_LONGINT:C283($FileNo)
C_LONGINT:C283($0)
$FileNo:=Table:C252($1)
READ WRITE:C146([x_id_numbers:3])
QUERY:C277([x_id_numbers:3]; [x_id_numbers:3]Table_Number:1=$FileNo)
If (Records in selection:C76([x_id_numbers:3])#1)
	CREATE RECORD:C68([x_id_numbers:3])
	[x_id_numbers:3]Table_Number:1:=$FileNo
	[x_id_numbers:3]ID_No:2:=Num:C11(Request:C163("Please enter starting ID number: "; "1"))
	SAVE RECORD:C53([x_id_numbers:3])
End if 
If (fLockNLoad(->[x_id_numbers:3]))
	$0:=[x_id_numbers:3]ID_No:2
	[x_id_numbers:3]ID_No:2:=[x_id_numbers:3]ID_No:2+1
	SAVE RECORD:C53([x_id_numbers:3])
Else 
	BEEP:C151
	ALERT:C41("Next ID_NUMBER process stopped by user")
	CANCEL:C270
	$0:=-1
End if 
UNLOAD RECORD:C212([x_id_numbers:3])
READ ONLY:C145([x_id_numbers:3])
//
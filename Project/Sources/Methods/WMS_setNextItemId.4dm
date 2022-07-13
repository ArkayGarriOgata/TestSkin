//%attributes = {"publishedWeb":true}
//PM: WMS_setNextItemId() -> 
//@author mlb - 4/30/03  15:51

//see also  WMS_getNextItemId

C_LONGINT:C283($2; $0)
C_POINTER:C301($1)
C_LONGINT:C283($FileNo)
$FileNo:=Table:C252($1)

If ([x_id_numbers:3]Table_Number:1=$FileNo)
	If (fLockNLoad(->[x_id_numbers:3]))
		[x_id_numbers:3]ID_No:2:=$2
		SAVE RECORD:C53([x_id_numbers:3])
		$0:=[x_id_numbers:3]ID_No:2
		UNLOAD RECORD:C212([x_id_numbers:3])
		READ ONLY:C145([x_id_numbers:3])
	End if 
	
Else 
	READ WRITE:C146([x_id_numbers:3])
	QUERY:C277([x_id_numbers:3]; [x_id_numbers:3]Table_Number:1=$FileNo)
	If (Records in selection:C76([x_id_numbers:3])#1)
		CREATE RECORD:C68([x_id_numbers:3])
		[x_id_numbers:3]Table_Number:1:=$FileNo
		[x_id_numbers:3]ID_No:2:=$2
		SAVE RECORD:C53([x_id_numbers:3])
	End if 
	
	$0:=-1
	If (fLockNLoad(->[x_id_numbers:3]))
		[x_id_numbers:3]ID_No:2:=$2
		SAVE RECORD:C53([x_id_numbers:3])
		$0:=[x_id_numbers:3]ID_No:2
	Else 
		BEEP:C151
		ALERT:C41("Set ID_NUMBER process stopped by user")
		CANCEL:C270
	End if 
	
	UNLOAD RECORD:C212([x_id_numbers:3])
	READ ONLY:C145([x_id_numbers:3])
End if 
//EOP
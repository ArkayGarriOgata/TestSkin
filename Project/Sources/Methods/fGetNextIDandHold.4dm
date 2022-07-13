//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 10/12/06, 14:21:08
// ----------------------------------------------------
// Method: fGetNextIDandHold(filenumber) -> next id
// Description
// rtn next number and keep record locked
//
// Parameters
// ----------------------------------------------------

C_LONGINT:C283($1)
C_LONGINT:C283($0; last_number_issued)

If (Count parameters:C259=1)
	READ WRITE:C146([x_id_numbers:3])
	QUERY:C277([x_id_numbers:3]; [x_id_numbers:3]Table_Number:1=$1)
	If (Records in selection:C76([x_id_numbers:3])#1)
		CREATE RECORD:C68([x_id_numbers:3])
		[x_id_numbers:3]Table_Number:1:=$FileNo
		[x_id_numbers:3]ID_No:2:=Num:C11(Request:C163("Please enter starting ID number: "; "1"))
		SAVE RECORD:C53([x_id_numbers:3])
	End if 
	
	If (fLockNLoad(->[x_id_numbers:3]))
		last_number_issued:=[x_id_numbers:3]ID_No:2
		
	Else 
		UNLOAD RECORD:C212([x_id_numbers:3])
		READ ONLY:C145([x_id_numbers:3])
		BEEP:C151
		ALERT:C41("Next ID_NUMBER process stopped by user")
		last_number_issued:=-1
	End if 
	$0:=last_number_issued
	
Else   //shoud be loaded from last time
	If (last_number_issued=[x_id_numbers:3]ID_No:2)  //hoping that we are on the same record
		[x_id_numbers:3]ID_No:2:=[x_id_numbers:3]ID_No:2+$2
		$0:=[x_id_numbers:3]ID_No:2
		SAVE RECORD:C53([x_id_numbers:3])
	Else 
		$0:=-2
	End if 
	UNLOAD RECORD:C212([x_id_numbers:3])
	READ ONLY:C145([x_id_numbers:3])
	last_number_issued:=-3
End if 
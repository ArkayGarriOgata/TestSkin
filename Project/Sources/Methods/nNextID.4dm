//%attributes = {"publishedWeb":true}
//(P) nNextID: Obtains next ID for record key
//• 9/22/97 cs stopped search message from appearing
//•102198  MLB  I think the locking is flawed in this proc, it assumes that lock 
//   is eventually obtained, conflicts between PO, Req, and Job bag prompted this 
//   attempted at a fix, to use standard primeKey generator
//•102298  MLB  make allowance for Req fake file number

MESSAGES OFF:C175

C_LONGINT:C283($0; $1; $2)  //$1 = File No parameter, $2 = Starting ID number value (optional)

If (True:C214)
	C_POINTER:C301($filePtr)
	
	If ($1<256)
		$filePtr:=Table:C252($1)
		$0:=fGetNextLongInt($filePtr)
	Else 
		READ WRITE:C146([x_id_numbers:3])
		QUERY:C277([x_id_numbers:3]; [x_id_numbers:3]Table_Number:1=$1)
		If (Records in selection:C76([x_id_numbers:3])#1)
			CREATE RECORD:C68([x_id_numbers:3])
			[x_id_numbers:3]Table_Number:1:=$1
			[x_id_numbers:3]ID_No:2:=Num:C11(Request:C163("Please enter starting number: "; "1"))
			SAVE RECORD:C53([x_id_numbers:3])
		End if 
		If (fLockNLoad(->[x_id_numbers:3]))
			$0:=[x_id_numbers:3]ID_No:2
			[x_id_numbers:3]ID_No:2:=[x_id_numbers:3]ID_No:2+1
			SAVE RECORD:C53([x_id_numbers:3])
		Else 
			BEEP:C151
			ALERT:C41("Next ID_NUMBER process for table "+String:C10($1)+" stopped by user")
			CANCEL:C270
			$0:=-1
		End if 
		UNLOAD RECORD:C212([x_id_numbers:3])
		READ ONLY:C145([x_id_numbers:3])
	End if 
	
Else   //old way
	READ WRITE:C146([x_id_numbers:3])
	QUERY:C277([x_id_numbers:3]; [x_id_numbers:3]Table_Number:1=$1)
	If ([x_id_numbers:3]Table_Number:1#$1)  //does this work-if not, try  IF( records in selection(...)=0)
		CREATE RECORD:C68([x_id_numbers:3])
		[x_id_numbers:3]Table_Number:1:=$1
		If (Count parameters:C259=1)
			[x_id_numbers:3]ID_No:2:=Num:C11(Request:C163("Please enter starting ID number! "; "1"))
		Else 
			[x_id_numbers:3]ID_No:2:=$2
		End if 
	End if 
	uMyLoadRec(->[x_id_numbers:3])
	$0:=[x_id_numbers:3]ID_No:2
	[x_id_numbers:3]ID_No:2:=[x_id_numbers:3]ID_No:2+1
	SAVE RECORD:C53([x_id_numbers:3])
	uMyUnlock(->[x_id_numbers:3])
	MESSAGES ON:C181
End if 
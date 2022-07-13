//%attributes = {"publishedWeb":true}
//(P) gResetID: Resets next ID if New record cancelled 
//• 9/22/97 cs stopped searching message
//•010699  MLB  use fLockNload

C_LONGINT:C283($1; $2)  //$1 = File No parameter, $2 = Used ID Number

READ WRITE:C146([x_id_numbers:3])
QUERY:C277([x_id_numbers:3]; [x_id_numbers:3]Table_Number:1=$1)

If (fLockNLoad(->[x_id_numbers:3]))
	If ([x_id_numbers:3]ID_No:2=($2+1))  //No change between assignment and reset
		[x_id_numbers:3]ID_No:2:=$2  //Set back to previous number
		SAVE RECORD:C53([x_id_numbers:3])
	End if 
End if 

REDUCE SELECTION:C351([x_id_numbers:3]; 0)
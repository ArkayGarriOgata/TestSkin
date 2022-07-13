//%attributes = {"executedOnServer":true}
C_TEXT:C284($1)
READ WRITE:C146([x_id_numbers:3])
ALL RECORDS:C47([x_id_numbers:3])

While (Not:C34(End selection:C36([x_id_numbers:3])))
	[x_id_numbers:3]ServerDesignation:7:=$1
	[x_id_numbers:3]Seq_Offset:3:=[x_id_numbers:3]Seq_Offset:3  //0
	If ([x_id_numbers:3]Table_Number:1<256)
		[x_id_numbers:3]Usage:5:=Table name:C256([x_id_numbers:3]Table_Number:1)
	End if 
	SAVE RECORD:C53([x_id_numbers:3])
	NEXT RECORD:C51([x_id_numbers:3])
End while 


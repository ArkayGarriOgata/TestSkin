$new:=Num:C11(Request:C163("What should the next new id be:"))
If (ok=1)
	$fileptr:=Table:C252([x_id_numbers:3]Table_Number:1)
	$current:=app_AutoIncrement($fileptr)
	[x_id_numbers:3]Seq_Offset:3:=$new-$current
	
Else 
	BEEP:C151
End if 
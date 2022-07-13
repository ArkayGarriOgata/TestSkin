//(S) [ID NUMBERS]IDMaint'File No)

If ([x_id_numbers:3]Table_Number:1<1) | ([x_id_numbers:3]Table_Number:1>9999)
	uConfirm("Invalid File Number! Enter greater than 0, less than 10000."; "OK"; "Help")
	REJECT:C38([x_id_numbers:3]Table_Number:1)
Else 
	If ([x_id_numbers:3]Table_Number:1<=Get last table number:C254)
		If (Is table number valid:C999([x_id_numbers:3]Table_Number:1))
			[x_id_numbers:3]Usage:5:=Table name:C256([x_id_numbers:3]Table_Number:1)
		End if 
	End if 
End if 
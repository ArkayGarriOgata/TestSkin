//(s) [pSpec]foiltype.input
If (Self:C308->#"")
	If (Position:C15("Test"; [Process_Specs:18]Stock:7)>0) | (Position:C15("Cover"; [Process_Specs:18]Stock:7)>0)
		uConfirm("You Have Previously Selected a 'Wrap' type Stock, this is NOT Allowed."+<>sCr+"You May REMOVE the Stock, or"+<>sCr+"You May CANCEL this Foil."; "Remove Stock"; "Cancel \\x11.")
		If (OK=1)
			[Process_Specs:18]Stock:7:=""
		Else 
			Self:C308->:=Old:C35(Self:C308->)
		End if 
	End if 
End if 
//eos
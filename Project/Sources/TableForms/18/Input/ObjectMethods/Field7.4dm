//(s) [prcocess spec]stock.input
If (Position:C15("Test"; Self:C308->)>0) | (Position:C15("Cover"; Self:C308->)>0)
	If ([Process_Specs:18]FoilType:9#"")
		BEEP:C151
		uConfirm("You Have a Foil Selected, this is NOT Allowed."+<>sCr+"You May REMOVE the Foil, or"+<>sCr+"You May CANCEL this Entry."; "Remove Foil"; "Cancel \\x11.")
		If (OK=1)
			[Process_Specs:18]FoilType:9:=""
		Else 
			Self:C308->:=Old:C35(Self:C308->)
		End if 
	End if 
End if 
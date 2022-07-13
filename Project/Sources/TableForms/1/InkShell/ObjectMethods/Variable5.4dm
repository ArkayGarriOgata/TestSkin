//(s) sCriterion4
//• 2/10/98 cs added test for bad color entry
If (Self:C308->=sCriterion2)
	uConfirm("Uhhh..... You are supposed to be entering a COLOR."+Char:C90(13)+"Please enter a color, not a Material Code."; "Try Again"; "Help")
	Self:C308->:=""
	GOTO OBJECT:C206(Self:C308->)
Else 
	txt_CapNstrip(Self:C308)
End if 
//
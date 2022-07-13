If (Num:C11(Self:C308->)<1) | (Num:C11(Self:C308->)>99)
	ALERT:C41("The entered Commodity Code is invald."+Char:C90(13)+"Please re-enter.")
	Self:C308->:=""
	GOTO OBJECT:C206(Self:C308->)
End if 
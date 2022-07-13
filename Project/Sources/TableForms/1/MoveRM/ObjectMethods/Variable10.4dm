//(p) tSubgroup [control]MoveRM
If (Length:C16(Self:C308->)>17)
	Self:C308->:=Substring:C12(Self:C308->; 1; 17)
	ALERT:C41("The maximum length of a Subgroup name is 17 characters."+Char:C90(13)+"Truncating entry to "+Self:C308->)
Else 
	RM_MoveSubgroup("F")
End if 
//
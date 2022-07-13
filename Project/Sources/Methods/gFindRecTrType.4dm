//%attributes = {"publishedWeb":true}
//(P) gFindRecTrType

C_LONGINT:C283($i)

If (sType="")
	sRecType:=""
Else 
	$i:=Find in array:C230(<>asRecType; sType)
	sRecType:=<>asRecDesc{$i}
End if 
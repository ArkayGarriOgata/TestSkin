//%attributes = {"publishedWeb":true}
C_TEXT:C284($0)  //(P) gFindReordPol
C_LONGINT:C283($i)

If ([Raw_Materials:21]ReorderPolicy:11="")
	$0:=""
Else 
	$i:=Find in array:C230(<>asReordPol; [Raw_Materials:21]ReorderPolicy:11)
	$0:=<>asReordDesc{$i}
End if 
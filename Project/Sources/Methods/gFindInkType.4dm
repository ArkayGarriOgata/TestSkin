//%attributes = {"publishedWeb":true}
//(P) gFindInkType

C_LONGINT:C283($i)

If ([Raw_Materials:21]CompanyID:27="")
	sInkType:=""
Else 
	$i:=Find in array:C230(<>asInkType; [Raw_Materials:21]CompanyID:27)
	sInkType:=<>asInkDesc{$i}
End if 
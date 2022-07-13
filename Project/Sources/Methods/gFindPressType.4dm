//%attributes = {"publishedWeb":true}
//(P) gFindPressType

C_LONGINT:C283($i)

If ([Raw_Materials:21]DepartmentID:28="")
	sPressType:=""
Else 
	$i:=Find in array:C230(<>asPressType; [Raw_Materials:21]DepartmentID:28)
	sPressType:=<>asPressDesc{$i}
End if 
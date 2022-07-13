//%attributes = {"publishedWeb":true}
//PM: NewFolder(path) -> 0 if ok
//@author mlb - 9/5/02  11:37
//replacement for FilePack

C_TEXT:C284($1)
C_LONGINT:C283($0)

OK:=0

If (Test path name:C476($1)<0)
	CREATE FOLDER:C475($1)
	$0:=Num:C11(Not:C34(OK=1))
Else 
	$0:=0
End if 
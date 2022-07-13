//%attributes = {"publishedWeb":true}
//(P) uNextView(string) -> integer

C_TEXT:C284($1)
C_LONGINT:C283($loc; $0)

$loc:=Find in array:C230(<>aViewName; $1)
If ($loc=-1)
	While (Semaphore:C143("$ModViewArrays"))
		DELAY PROCESS:C323(Current process:C322; 1)
	End while 
	$loc:=Size of array:C274(<>aViewName)+1
	ARRAY TEXT:C222(<>aViewName; $loc)
	ARRAY LONGINT:C221(<>aViewNum; $loc)
	<>aViewName{$loc}:=$1
	CLEAR SEMAPHORE:C144("$ModViewArrays")
End if 
<>aViewNum{$loc}:=<>aViewNum{$loc}+1
$0:=<>aViewNum{$loc}
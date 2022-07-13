//%attributes = {"publishedWeb":true}
//PM: RM_AllocationRptNewPage(linesSoFar) -> linesSoFar
//@author mlb - 6/24/02  10:37

C_LONGINT:C283($1; $0; $line; $maxLines)
C_TEXT:C284($2)

$maxLines:=30
$line:=$1

If ($line>=$maxLines)
	PAGE BREAK:C6(>)
	iPage:=iPage+1
	Print form:C5([Raw_Materials:21]; "RMAllocHdr2")
	$line:=0
	//tText:=""
	If (Count parameters:C259=2)
		$line:=RM_AllocationRptPrintLine($line; $2)
	End if 
End if 

$0:=$line
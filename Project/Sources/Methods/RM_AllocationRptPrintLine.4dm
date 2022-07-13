//%attributes = {"publishedWeb":true}
//PM: RM_AllocationRptPrintLine(line;text) -> 
//@author mlb - 6/25/02  11:07

C_LONGINT:C283($1; $line)
C_TEXT:C284($2; tText)

$line:=$1
If (Length:C16($2)>0)
	tText:=$2
	Print form:C5([Raw_Materials:21]; "RMAllocLineItem")
	$line:=$line+1
End if 

$0:=$line
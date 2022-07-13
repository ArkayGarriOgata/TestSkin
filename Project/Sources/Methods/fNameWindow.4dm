//%attributes = {"publishedWeb":true}
C_TEXT:C284($0; $selected; $outOf)  //window title:=fNameWindow(»file)
C_POINTER:C301($1)
$selected:=String:C10(Records in set:C195("◊LastSelection"+String:C10(Table:C252($1))))
$outOf:=String:C10(Records in table:C83($1->))
$0:=sFile+": "+$selected+" of "+$outOf  // Modified by: Mark Zinke (12/20/12) Removed leading space.
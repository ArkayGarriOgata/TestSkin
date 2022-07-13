// _______
// Method: [zz_control].eBag_dio.ColdFoil   ( ) ->
// By: Mel Bohince @ 07/22/21, 10:23:42
// Description
// log cold foil usage
// ----------------------------------------------------

C_LONGINT:C283($tabNumber; $itemRef)
C_TEXT:C284($itemText; $Seq; $jobSequence; $schdCC)

$tabNumber:=Selected list items:C379(ieBagTabs)
GET LIST ITEM:C378(ieBagTabs; $tabNumber; $itemRef; $itemText)
$Seq:=String:C10(Num:C11(Substring:C12($itemText; 1; 3)); "000")
$jobSequence:=sCriterion1+"."+$Seq
$schdCC:=PS_getCostCenter($jobSequence)

RM_ColdFoilUsage($jobSequence; $schdCC)


//%attributes = {}
//Method:  Core_HList_GetKeyT(nHListNumber)->tKey
//Description:  This method returns the key value associated to a HList

If (True:C214)  //Initialize
	
	C_LONGINT:C283($1; $nHListNumber)
	C_TEXT:C284($0; $tKey)
	
	C_POINTER:C301($pHListList; $patKey)
	C_LONGINT:C283($nItemPos; $nItemRef; $nSubList)
	C_TEXT:C284($tItemText)
	C_BOOLEAN:C305($bExpanded)
	
	$nHListNumber:=$1
	
	$tKey:=CorektBlank
	
	$pHListList:=OBJECT Get pointer:C1124("CorenHListList"+String:C10($nHListNumber))
	$patKey:=OBJECT Get pointer:C1124("CoreatHListKey"+String:C10($nHListNumber))
	
	$nItemPos:=Selected list items:C379($pHListList->)
	
	GET LIST ITEM:C378($pHListList->; $nItemPos; $nItemRef; $tItemText; $nSubList; $bExpanded)
	
End if   //Done Initialize

If ($nItemRef<=Size of array:C274($patKey->))
	$tKey:=$patKey->{$nItemRef}
End if 

$0:=$tKey

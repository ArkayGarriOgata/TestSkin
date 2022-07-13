//%attributes = {}
//Method:  Core_HList_IsFolderB (pHList)=>bIsFolder
//Description:  This method determines if clicking on a folder 

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($0; $bIsFolder)
	C_POINTER:C301($1; $pHList)
	C_BOOLEAN:C305($bExpanded)
	C_LONGINT:C283($nHList; $nItem; $nItemRef; $nSubList)
	C_TEXT:C284($tItemText)
	
	$pHList:=$1
	$bIsFolder:=False:C215
	
	$nHList:=$pHList->
	
	$nItem:=Selected list items:C379($nHList)
	
	GET LIST ITEM:C378($nHList; $nItem; $nItemRef; $tItemText; $nSubList; $bExpanded)
	
End if   //Done Initialize

$bIsFolder:=Core_Convert_NumberB($nSubList)

$0:=$bIsFolder

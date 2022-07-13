//%attributes = {}
// _______
// Method: app_form_Notice_Text   ( ) ->
// By: Mel Bohince @ 04/21/20, 16:52:18
// Description
// 
// ----------------------------------------------------

C_TEXT:C284($field; $noticeText; $0)
C_COLLECTION:C1488($1; $fieldList_c)
$fieldList_c:=$1

C_OBJECT:C1216($entity; $2)
$entity:=$2
ARRAY TEXT:C222($aProperties; 0)

OB GET PROPERTY NAMES:C1232($entity; $aProperties)

$noticeText:=""

If (Size of array:C274($aProperties)>0)
	
	For each ($field; $fieldList_c)
		If (Find in array:C230($aProperties; $field)>-1)  //entity has such a property
			$noticeText:=$noticeText+$entity[$field]+" "
		End if 
	End for each 
	
End if 

zwStatusMsg("REFERENCE"; $noticeText)

$0:=$noticeText

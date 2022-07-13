//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 11/04/10, 13:18:29
// ----------------------------------------------------
// Method: app_IncludedRecordDelete(->[y_batch_email_distributions]BatchName;->[y_batch_distribution_list]EmailAddress;"ListboxSet0")
// Description
// Used to replace "Delete subrecord" automatic action when subtable removed
// ----------------------------------------------------

C_POINTER:C301($1; $ptrOneField; $2; $ptrIncludedFieldToConfirm; $ptrIncludedTable)
C_TEXT:C284($3; $listBoxHighliteSetName)

$ptrOneField:=$1
$ptrIncludedFieldToConfirm:=$2
$ptrIncludedTable:=Table:C252(Table:C252($ptrIncludedFieldToConfirm))
$listBoxHighliteSetName:=$3

If (Records in set:C195($listBoxHighliteSetName)>0)
	USE SET:C118($listBoxHighliteSetName)
	uConfirm("Delete the highlighted record? ["+$ptrIncludedFieldToConfirm->+"]"; "Cancel"; "Delete")
	If (OK=0)
		util_DeleteSelection($ptrIncludedTable)
	End if 
	//CLEAR SET($listBoxHighliteSetName) `if you clear this then you can't make another selection
	
	//now display it
	RELATE MANY:C262($ptrOneField->)
	ORDER BY:C49($ptrIncludedTable->; $ptrIncludedFieldToConfirm->; >)
	
Else 
	uConfirm("You must first highlight the record to delete."; "OK"; "Help")
End if 
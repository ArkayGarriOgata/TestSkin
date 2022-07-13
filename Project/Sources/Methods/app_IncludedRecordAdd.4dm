//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 11/04/10, 13:08:08
// ----------------------------------------------------
// Method: app_IncludedRecordAdd(->[y_batch_email_distributions]BatchName;->[y_batch_distribution_list]BatchName;->[y_batch_distribution_list]EmailAddress;"_firstname.lastname@arkay.com")
// Description
// used to replace "Add subrecord" automatic action when subtable removed
// ----------------------------------------------------

$ptrPrimaryKey:=$1  //from the one table
$ptrForeignKey:=$2  //from the many table
$ptrRelatedTable:=Table:C252(Table:C252($ptrForeignKey))  //need a table ptr

If (Count parameters:C259>2)
	$ptrPrePopulate:=$3  //option to init one value in new record
	$initialValue:=$4  //optional value to use
End if 

//make the record
CREATE RECORD:C68($ptrRelatedTable->)
$ptrForeignKey->:=$ptrPrimaryKey->
If (Count parameters:C259>2)
	If (Type:C295($ptrPrePopulate->)=Is alpha field:K8:1) | (Type:C295($ptrPrePopulate->)=Is text:K8:3)
		$ptrPrePopulate->:=$initialValue
	Else 
		$ptrPrePopulate->:=Num:C11($initialValue)
	End if 
End if 
SAVE RECORD:C53($ptrRelatedTable->)

//now display it
RELATE MANY:C262($ptrPrimaryKey->)
ORDER BY:C49($ptrRelatedTable->; $ptrPrePopulate->; >)
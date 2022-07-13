//%attributes = {"publishedWeb":true}
//uLinkRelatedDel()      -JML    8/16/93
//`delete relation between Vendor & Contact  (and other many-many 
//relationships)


//Want to ask use if she wishes to delete link record,
//at a minimum, show the ID of record to be deleted
//$1 = pointer to id field of related record.
//new to ensure that a record is actually selected.
C_POINTER:C301($1; $2; $FilePtr)
C_TEXT:C284($3)

//$1= pointer to link file related ID field 
//$2= pointer to current file ID field 
//$3 = string representation of related file name
$FilePtr:=Table:C252(Table:C252($1))  //returns file pointer fo this field

If ($1->#"")  //a bad way of deteremining if a record is selected in link file
	//This Confirm should say something like:
	//Do you really wish to remove the relationship to Vendor #465?"
	CONFIRM:C162("Do you really wish to remove the relationship to "+$3+" #"+$1->+"?")
	If (OK=1)
		C_TEXT:C284($Value)
		$Value:=$2->  //get paretn record's current ID value
		
		DELETE RECORD:C58($FilePtr->)
		QUERY:C277($FilePtr->; $2->=$Value)  //restore included list for parent record
		REDRAW:C174($FilePtr->)
		
		//a relate many is not used because it could detrimentally effect another rletion
		//to same ID field
	End if 
	
Else 
	uConfirm("Double click the record you wish to remove first."; "Try again"; "Help")
End if 
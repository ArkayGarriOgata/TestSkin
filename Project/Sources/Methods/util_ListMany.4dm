//%attributes = {"publishedWeb":true}
//PM: util_ListMany() -> 
//formerly  `(P) uQRListMany: Lists related many file data on quick report
//call as a formula in a Quick Report column. Must be preceeded by uQRGetMany
//Example: uQRListMany(»[MANY]Dollars;"$#,###.00")

C_LONGINT:C283($i; $FieldType; $Num)
C_TEXT:C284($CR)  //$1 = Pointer to Many Field
C_TEXT:C284($2; $Fmt)  //$2=Format String
C_POINTER:C301($1; $FilePtr)

If (Count parameters:C259>1)  //Format passed?
	$Fmt:=$2
Else 
	$Fmt:=""  //Ensure contents in interpreted
End if 
$Num:=Num:C11($Fmt)  //Convert format to a number
$FilePtr:=Table:C252(Table:C252($1))
$0:=""  //Defaults to text type
$FieldType:=Type:C295($1->)  //Get type of field
$CR:=Char:C90(13)

FIRST RECORD:C50($FilePtr->)

For ($i; 1; Records in selection:C76($FilePtr->))  //Loop thru related many records
	Case of 
		: (($FieldType=0) | ($FieldType=2) | ($FieldType=24))  //String field type
			$0:=$0+$1->+$CR  //Concatenate relating data, no format needed
		: (($FieldType=1) | ($FieldType=8) | ($FieldType=9))  //Numeric field type
			$0:=$0+String:C10($1->; $Fmt)+$CR  //Concatenate relating data using passed format
		: (($FieldType=4) | ($FieldType=11))  //Date or Time field type
			$0:=$0+String:C10($1->; $Num)+$CR  //Concatenate relating data using passed format number
		: ($FieldType=6)  //Boolean field type
			$0:=$0+String:C10($1->)+$CR  //Concatenate relating data, no format needed
	End case 
	NEXT RECORD:C51($FilePtr->)
End for 
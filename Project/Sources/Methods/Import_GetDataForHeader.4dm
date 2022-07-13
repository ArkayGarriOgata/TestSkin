//%attributes = {}
//$1=Header name
C_TEXT:C284($0; $1)
$0:=""
$xlFind:=Find in array:C230(sttImportHeaders; $1)
If (($xlFind>0) & ($xlFind<=Size of array:C274(sttImportFields)))
	$0:=sttImportFields{$xlFind}
End if 
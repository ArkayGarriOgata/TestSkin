//%attributes = {"publishedWeb":true}
//PM: util_GetMany() -> 
//formerly `(P) uQRGetMany: Gets relate file data for quick report
//call as a formula in a hidden Quick Report column. Must be before uQRListMany
//Example: uQRGetMany(»[ONE]Relator;»[MANY]File1;»[MANY]File2;...)

C_LONGINT:C283($i)
C_POINTER:C301($1; $2; ${2})  //$1 = Pointer to One File Field
C_TEXT:C284($FileName)  // $2...$5 = Pointer to Many File Sort Fields, Max 4
C_TEXT:C284($Sort)

$FileName:=Table name:C256(Table:C252($2))
RELATE MANY:C262($1->)

If (Count parameters:C259>1)
	MESSAGES OFF:C175
	$Sort:="SORT SELECTION(["+$FileName+"]"
	For ($i; 2; Count parameters:C259)
		$Sort:=$Sort+";["+$FileName+"]"+Field name:C257(${$i})+";>"
	End for 
	$Sort:=$Sort+")"
	EXECUTE FORMULA:C63($Sort)
	MESSAGES ON:C181
End if 
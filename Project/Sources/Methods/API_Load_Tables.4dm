//%attributes = {}
// _______
// Method: API_Load_Tables   ( ) ->
// By: Angelo @ --/--/19, --:--:--
// Description
// 
// ----------------------------------------------------


C_COLLECTION:C1488($colTables; $0)
C_OBJECT:C1216($obTables; $obTable; $obField)
C_TEXT:C284($jsonPath; $json)

$colTables:=New collection:C1472

$jsonPath:=Get 4D folder:C485(Database folder:K5:14; *)+"params"+Folder separator:K24:12+"tables.json"

If (Test path name:C476($jsonPath)=Is a document:K24:1)
	$json:=Document to text:C1236($jsonPath)
	$colTables:=JSON Parse:C1218($json)
	
Else 
	
	$lastTable:=Get last table number:C254
	
	For ($i; 1; $lastTable)
		If (Is table number valid:C999($i))
			$obTable:=New object:C1471("tableName"; Table name:C256($i); "publish"; True:C214; "num"; $i)
			
			
			
			$lastField:=Get last field number:C255($i)
			
			$obTable.fields:=New collection:C1472
			
			For ($j; 1; $lastField)
				
				
				If (Is field number valid:C1000($i; $j))
					$obField:=New object:C1471("fieldName"; Field name:C257($i; $j); "publish"; True:C214; "num"; $j)
					
					$obTable.fields.push($obField)
					
				End if 
				
			End for 
			
			$colTables.push($obTable)
		End if 
		
	End for 
End if 

$0:=$colTables
//%attributes = {}
//Method:  Core_Record_DocRelated(paPrimaryKey;papRelatedField)
//Description:  This method will loop thru primary key and report a count
// for related records in related field.

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $paPrimaryKey; $2; $papRelatedField)
	
	C_LONGINT:C283($nPrimaryKey; $nNumberOfPrimaryKeys)
	C_LONGINT:C283($nTable; $nNumberOfTables)
	C_LONGINT:C283($nPrimaryKeyCount; $nPrimaryKeyNumber)
	C_LONGINT:C283($nRelatedTable; $nRelatedFieldType)
	
	C_TEXT:C284($tFieldName; $tPrimaryKey; $tTableName)
	C_TEXT:C284($tPrimaryKey)
	
	C_POINTER:C301($pRelatedTable; $pRelatedField)
	
	C_OBJECT:C1216($oProgress)
	
	ARRAY LONGINT:C221($anOrderNumber; 0)
	
	ARRAY TEXT:C222($atTableName; 0)
	ARRAY TEXT:C222($atFieldName; 0)
	ARRAY TEXT:C222($atPrimaryKey; 0)
	ARRAY TEXT:C222($atPrimaryKeyCount; 0)
	
	ARRAY POINTER:C280($apColumn; 0)
	
	$paPrimaryKey:=$1
	$papRelatedField:=$2
	
	$nNumberOfPrimaryKeys:=Size of array:C274($paPrimaryKey->)
	$nNumberOfTables:=Size of array:C274($papRelatedField->)
	
	APPEND TO ARRAY:C911($apColumn; ->$atTableName)
	APPEND TO ARRAY:C911($apColumn; ->$atFieldName)
	APPEND TO ARRAY:C911($apColumn; ->$atPrimaryKey)
	APPEND TO ARRAY:C911($apColumn; ->$atPrimaryKeyCount)
	
	$oProgress:=New object:C1471()
	
	$oProgress.nProgressID:=Prgr_NewN
	$oProgress.nNumberOfLoops:=$nNumberOfPrimaryKeys
	$oProgress.tTitle:="Counting Related Records"
	
End if   //Done initialize

GET QUERY DESTINATION:C1155($nQueryType; $tQueryObject; $pQuery)

SET QUERY DESTINATION:C396(Into variable:K19:4; $nPrimaryKeyCount)

For ($nPrimaryKey; 1; $nNumberOfPrimaryKeys)  //Primary key
	
	If (Prgr_ContinueB($oProgress))  //Progress
		
		$nPrimaryKeyType:=Type:C295($paPrimaryKey->)
		
		Case of 
			: ($nPrimaryKeyType=LongInt array:K8:19)
				
				$nPrimaryKeyNumber:=$paPrimaryKey->{$nPrimaryKey}
				$tPrimaryKey:=String:C10($nPrimaryKeyNumber)
				
			: ($nPrimaryKeyType=Text array:K8:16)
				
				$tPrimaryKey:=$paPrimaryKey->{$nPrimaryKey}
				$nPrimaryKeyNumber:=Num:C11($tPrimaryKey)
				
		End case 
		
		$oProgress.nLoop:=$nPrimaryKey
		$oProgress.tMessage:="Counting records related to "+$tPrimaryKey
		
		Prgr_Message($oProgress)
		
		For ($nTable; 1; $nNumberOfTables)  //Table
			
			$pRelatedField:=$papRelatedField->{$nTable}
			
			$nRelatedFieldType:=Type:C295($pRelatedField)
			
			$nRelatedTable:=Table:C252($pRelatedField)
			$pRelatedTable:=Table:C252($nRelatedTable)
			
			$tTableName:=Table name:C256($pRelatedTable)
			$tFieldName:=Field name:C257($pRelatedField)
			
			READ ONLY:C145($pRelatedTable->)
			
			$nPrimaryKeyCount:=0
			
			Case of   //Query
					
				: ($nRelatedFieldType=Is longint:K8:6)
					
					QUERY:C277($pRelatedTable->; $pRelatedField->=$nPrimaryKeyNumber)
					
				Else 
					
					QUERY:C277($pRelatedTable->; $pRelatedField->=$tPrimaryKey)
					
			End case   //Done query
			
			APPEND TO ARRAY:C911($atTableName; $tTableName)
			APPEND TO ARRAY:C911($atFieldName; $tFieldName)
			APPEND TO ARRAY:C911($atPrimaryKey; $tPrimaryKey)
			APPEND TO ARRAY:C911($atPrimaryKeyCount; String:C10($nPrimaryKeyCount))
			
		End for   //Done tables
		
	End if   //Done progress
	
End for   //Done primary keys

SET QUERY DESTINATION:C396($nQueryType; $tQueryObject; $pQuery)

Prgr_Quit($oProgress)

Core_Array_ToDocument(->$apColumn)
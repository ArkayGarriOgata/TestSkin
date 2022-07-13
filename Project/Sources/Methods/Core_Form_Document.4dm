//%attributes = {}
//Method: Core_Form_Document(tFolder;patPathname)
//Description: This method creates two documents of a form
//. a screen shot and a document with field and field value
//.  It will also append the pathnames to the patPathname array

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tFolder)
	C_POINTER:C301($2; $patPathname)
	
	C_LONGINT:C283($nField; $nFieldNumber; $nTableNumber)
	C_LONGINT:C283($nNumberOfFields; $nNumberOfObjects; $nNumberOfRecords)
	C_LONGINT:C283($nObject; $nRecord)
	C_LONGINT:C283($nTable)
	
	C_TEXT:C284($taMsDocumentPath)
	C_TEXT:C284($tDetailFormName)
	C_TEXT:C284($tFolder; $tFormDataPath)
	C_TEXT:C284($tFormDocument; $tFormName)
	C_TEXT:C284($tNamedSelection; $tPrintScreenPath)
	C_TEXT:C284($tSelectionName)
	
	ARRAY TEXT:C222($atListBoxObjectName; 0)
	ARRAY TEXT:C222($atObjectName; 0)
	C_PICTURE:C286($gForm)
	
	ARRAY TEXT:C222($atObjectName; 0)
	ARRAY POINTER:C280($apObject; 0)
	
	ARRAY TEXT:C222($atFieldName; 0)
	ARRAY TEXT:C222($atFieldValue; 0)
	
	ARRAY POINTER:C280($apColumn; 0)
	
	ARRAY TEXT:C222($atListBoxObjectName; 0)
	ARRAY TEXT:C222($atObjectName; 0)
	
	$tFolder:=$1
	$patPathname:=$2
	
	$pFormTable:=Current form table:C627
	$tFormName:=Current form name:C1298
	
	APPEND TO ARRAY:C911($atFieldName; "Field Name")
	APPEND TO ARRAY:C911($atFieldValue; "Field Value")
	
	APPEND TO ARRAY:C911($apColumn; ->$atFieldName)
	APPEND TO ARRAY:C911($apColumn; ->$atFieldValue)
	
End if   //Done Initialize

If (Not:C34(Is nil pointer:C315($pFormTable)))  //Table form
	
	$tTableName:=Table name:C256($pFormTable)
	
	FORM SCREENSHOT:C940($gForm)
	
	FORM GET OBJECTS:C898($atObjectName; $apObject)
	
	$nNumberOfObjects:=Size of array:C274($apObject)
	
	For ($nObject; 1; $nNumberOfObjects)  //Loop thru objects
		
		RESOLVE POINTER:C394($apObject{$nObject}; $tVariable; $nTableNumber; $nFieldNumber)
		
		$nObjectType:=OBJECT Get type:C1300(*; $atObjectName{$nObject})
		
		Case of   //Field or table
				
			: (Is field number valid:C1000($nTableNumber; $nFieldNumber))  //Field
				
				$pField:=Field:C253($nTableNumber; $nFieldNumber)
				
				APPEND TO ARRAY:C911($atFieldName; Core_FieldNameT($pField))
				APPEND TO ARRAY:C911($atFieldValue; Core_CoercionT($pField))
				
			: (Is table number valid:C999($nTableNumber))  //Table
				
				$pTable:=Table:C252($nTableNumber)
				
				$nNumberOfRecords:=Records in selection:C76($pTable->)
				
				$nNumberOfFields:=Get last field number:C255($pTable)
				
				For ($nRecord; 1; $nNumberOfRecords)  //Records
					
					GOTO SELECTED RECORD:C245($pTable->; $nRecord)
					
					APPEND TO ARRAY:C911($atFieldName; "*** Record ***")
					APPEND TO ARRAY:C911($atFieldValue; String:C10($nRecord))
					
					For ($nField; 1; $nNumberOfFields)  //Fields
						
						If (Is field number valid:C1000($nTableNumber; $nField))  //Valid field
							
							$pField:=Field:C253($nTableNumber; $nField)
							
							APPEND TO ARRAY:C911($atFieldName; Core_FieldNameT($pField))
							APPEND TO ARRAY:C911($atFieldValue; Core_CoercionT($pField))
							
						End if   //Done valid field
						
					End for   //Done fields
					
				End for   //Done records
				
			: ($nObjectType=Object type listbox:K79:8)  //ListBox
				
				//Need to figure how to get listbox information (fhe following does no good)
				
				LISTBOX GET TABLE SOURCE:C1014(*; $atObjectName{$nObject}; $nTable; $tSelectionName)
				LISTBOX GET OBJECTS:C1302(*; $atObjectName{$nObject}; $atListBoxObjectName)
				$tNamedSelection:=LISTBOX Get property:C917(*; $atObjectName{$nObject}; lk named selection:K53:67)
				$tDetailFormName:=LISTBOX Get property:C917(*; $atObjectName{$nObject}; lk detail form name:K53:44)
				
		End case   //Done field or table
		
	End for   //Done looping thru objects
	
	$taMsDocumentPath:=util_DocumentPath+$tFolder+Folder separator:K24:12  //Returns {...}:Document:AMS_Documents:
	
	If (Test path name:C476($taMsDocumentPath)#Is a folder:K24:2)
		
		CREATE FOLDER:C475($taMsDocumentPath)
		
	End if 
	
	$tPrintScreenPath:=$taMsDocumentPath+$tTableName+"_"+Current form name:C1298
	
	WRITE PICTURE FILE:C680($tPrintScreenPath; $gForm; ".jpg")
	
	If (OK=1)
		APPEND TO ARRAY:C911($patPathname->; $tPrintScreenPath)
	End if 
	
	$tFormDocument:=$tTableName+"Data.txt"
	$tFormDataPath:=$taMsDocumentPath+$tFormDocument
	
	Core_Array_ToDocument(->$apColumn; $tFormDocument; $taMsDocumentPath)
	
	If (OK=1)
		APPEND TO ARRAY:C911($patPathname->; $tFormDataPath)
	End if 
	
	$hFormDocument:=Open document:C264($taMsDocumentPath+$tFormDocument)
	
	If (OK=1)
		
		SET DOCUMENT POSITION:C482($hFormDocument; 0; 1)
		
		SEND PACKET:C103($hFormDocument; "Form: ["+Table name:C256($pFormTable)+"];"+CorektDoubleQuote+$tFormName+CorektDoubleQuote+CorektCR)
		
		CLOSE DOCUMENT:C267($hFormDocument)
		
	End if 
	
End if   //Done table form

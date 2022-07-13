//%attributes = {}
//Method:  Core_Cltn_DocumentTo (cValue{;tDocumentName}{;tPathname})
//Description:  This method will store a collection to a document 

//  Example 1: 

//    C_COLLECTION($cName)
//    C_COLLECTION($cAge)

//    C_COLLECTION($cValue)

//    $cName:=New collection(\
               "John";\
               "Sally";\
               "Susan")

//    $cAge:=New collection(\
                30;\
                24;\
                33)

//    $cValue:=New collection()

//    $cValue.push($cName)
//    $cValue.push($cAge)

//    Core_Cltn_DocumentTo ($cValue)

//  Example 2:

//    C_COLLECTION($cName)

//    C_COLLECTION($cValue)

//    $cName:=New collection(\
               "John";\
               "Sally";\
               "Susan")

//    Core_Cltn_DocumentTo ($cName)

If (True:C214)  //Initialize
	
	C_COLLECTION:C1488($1; $cValue)
	C_TEXT:C284($2; $tDocumentName; $3; $tPathname)
	
	C_VARIANT:C1683($vRowValue)
	C_VARIANT:C1683($vColumnValue)
	
	C_LONGINT:C283($nNumberOfParameters)
	C_LONGINT:C283($nValueType)
	
	C_OBJECT:C1216($oPath)
	
	C_TEXT:C284($tColumn; $tRow)
	C_TEXT:C284($tDelimiter)
	C_TIME:C306($hDocumentReferenceID)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$cValue:=$1
	$tDocumentName:=CorektBlank
	$tPathname:=CorektBlank
	$nValueType:=Is undefined:K8:13
	
	If ($nNumberOfParameters>=2)  //Parameters
		$tDocumentName:=$2
		If ($nNumberOfParameters>=3)
			$tPathname:=$3
		End if 
	End if   //Done parameters
	
	$oPath:=New object:C1471()
	
	$oPath.tDocumentName:=$tDocumentName
	$oPath.tPathName:=$tPathname
	
End if   //Done initializing

$hDocumentReferenceID:=Core_Document_GetPathReferenceH($oPath)

If ($hDocumentReferenceID#?00:00:00?)  //Document
	
	For each ($vRow; $cValue)  //Row
		
		$tRow:=CorektBlank
		$nValueType:=Value type:C1509($vRow)
		
		If ($nValueType=Is collection:K8:32)
			
			For each ($vColumn; $vRow)  //Column
				
				$tRow:=$tRow+Core_Convert_ToTextT($vColumn)+Char:C90(Tab:K15:37)
				
			End for each   //Done column
			
		Else 
			
			$tRow:=Core_Convert_ToTextT($vRow)+Char:C90(Tab:K15:37)
			
		End if 
		
		$tRow:=Substring:C12($tRow; 1; Length:C16($tRow)-1)  //Remove the last tab
		
		$tRow:=$tRow+CorektCR
		
		SEND PACKET:C103($hDocumentReferenceID; $tRow)
		
	End for each   //Done row
	
	CLOSE DOCUMENT:C267($hDocumentReferenceID)
	
End if   //Done document

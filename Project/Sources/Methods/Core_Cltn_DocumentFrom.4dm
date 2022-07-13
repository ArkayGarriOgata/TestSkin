//%attributes = {}
//Method:  Core_Clcn_DocumentFrom (cValue{;tDocumentName}{;tPathname})
//Description:  This method will restore a collection to a document

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

//    $cValue:=New collection()

//    $cValue.push($cName)

//    Core_Cltn_DocumentTo ($cValue)

If (True:C214)  //Initialize
	
	C_COLLECTION:C1488($1; $cValue)
	C_TEXT:C284($2; $tDocumentName; $3; $tPathname)
	
	C_LONGINT:C283($nRow; $nNumberOfRows)
	C_LONGINT:C283($nColumn; $nNumberOfColumns)
	C_LONGINT:C283($nNumberOfParameters)
	C_LONGINT:C283($nType)
	C_LONGINT:C283($nMaximumNumberOfColumns)
	
	C_OBJECT:C1216($oPath)
	
	C_TEXT:C284($tColumn; $tRow)
	
	C_TIME:C306($hDocumentReferenceID)
	
	C_COLLECTION:C1488($cColumn00)
	C_COLLECTION:C1488($cColumn01)
	C_COLLECTION:C1488($cColumn02)
	C_COLLECTION:C1488($cColumn03)
	C_COLLECTION:C1488($cColumn04)
	C_COLLECTION:C1488($cColumn05)
	C_COLLECTION:C1488($cColumn06)
	C_COLLECTION:C1488($cColumn07)
	C_COLLECTION:C1488($cColumn08)
	C_COLLECTION:C1488($cColumn09)
	
	C_COLLECTION:C1488($cColumn10)
	C_COLLECTION:C1488($cColumn11)
	C_COLLECTION:C1488($cColumn12)
	C_COLLECTION:C1488($cColumn13)
	C_COLLECTION:C1488($cColumn14)
	C_COLLECTION:C1488($cColumn15)
	C_COLLECTION:C1488($cColumn16)
	C_COLLECTION:C1488($cColumn17)
	C_COLLECTION:C1488($cColumn18)
	C_COLLECTION:C1488($cColumn19)
	
	C_COLLECTION:C1488($cColumn20)
	C_COLLECTION:C1488($cColumn21)
	C_COLLECTION:C1488($cColumn22)
	C_COLLECTION:C1488($cColumn23)
	C_COLLECTION:C1488($cColumn24)
	C_COLLECTION:C1488($cColumn25)
	C_COLLECTION:C1488($cColumn26)
	C_COLLECTION:C1488($cColumn27)
	C_COLLECTION:C1488($cColumn28)
	C_COLLECTION:C1488($cColumn29)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$cValue:=$1
	$tDocumentName:=CorektBlank
	$tPathname:=CorektBlank
	
	If ($nNumberOfParameters>=2)  //Parameters
		$tDocumentName:=$2
		If ($nNumberOfParameters>=3)
			$tPathname:=$3
		End if 
	End if   //Done parameters
	
	$oPath:=New object:C1471()
	
	$oPath.tDocumentName:=$tDocumentName
	$oPath.tPathName:=$tPathname
	
	$nMaximumNumberOfColumns:=30  //From 00-29
	
	$cColumn00:=New collection:C1472()
	$cColumn01:=New collection:C1472()
	$cColumn02:=New collection:C1472()
	$cColumn03:=New collection:C1472()
	$cColumn04:=New collection:C1472()
	$cColumn05:=New collection:C1472()
	$cColumn06:=New collection:C1472()
	$cColumn07:=New collection:C1472()
	$cColumn08:=New collection:C1472()
	$cColumn09:=New collection:C1472()
	
	$cColumn10:=New collection:C1472()
	$cColumn11:=New collection:C1472()
	$cColumn12:=New collection:C1472()
	$cColumn13:=New collection:C1472()
	$cColumn14:=New collection:C1472()
	$cColumn15:=New collection:C1472()
	$cColumn16:=New collection:C1472()
	$cColumn17:=New collection:C1472()
	$cColumn18:=New collection:C1472()
	$cColumn19:=New collection:C1472()
	
	$cColumn20:=New collection:C1472()
	$cColumn21:=New collection:C1472()
	$cColumn22:=New collection:C1472()
	$cColumn23:=New collection:C1472()
	$cColumn24:=New collection:C1472()
	$cColumn25:=New collection:C1472()
	$cColumn26:=New collection:C1472()
	$cColumn27:=New collection:C1472()
	$cColumn28:=New collection:C1472()
	$cColumn29:=New collection:C1472()
	
End if   //Done initializing

$hDocumentReferenceID:=Core_Document_GetPathReferenceH($oPath)

If ($hDocumentReferenceID#?00:00:00?)  //Document
	
	$tValue:=Document to text:C1236(Document)
	
	//$cValue:=Core_Cltn_FromTextC ($tValue)
	
	If (False:C215)  //Temp code
		
		$nNumberOfRows:=($cValue.length)-1
		
		$nNumberOfColumns:=0
		
		If (Value type:C1509($cValue[0])=Is collection:K8:32)
			
			$nNumberOfColumns:=$cValue[0].length-1
			
		End if 
		
		For ($nRow; 0; $nNumberOfRows)  //Rows
			
			$tRow:=CorektBlank
			
			For ($nColumn; 0; $nNumberOfColumns)  //Columns
				
				$tColumn:=Core_Cltn_ConvertT($cValue; $nRow; $nColumn)
				
				$tRow:=$tRow+$tColumn+Char:C90(Tab:K15:37)
				
			End for   //Done columns
			
			$tRow:=Substring:C12($tRow; 1; Length:C16($tRow)-1)  //Remove the last tab
			
			$tRow:=$tRow+CorektCR
			
			RECEIVE PACKET:C104($hDocumentReferenceID; $tRow)
			
		End for   //Done rows
		
		CLOSE DOCUMENT:C267($hDocumentReferenceID)
		
	End if   //Done temp code
End if   //Done document

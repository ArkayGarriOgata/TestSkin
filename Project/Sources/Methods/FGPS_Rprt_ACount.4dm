//%attributes = {}
//Method:  FGPS_Rprt_ACount
//Description:  This method will calculate FileOutlineNumber and CaseSize
If (True:C214)  //Initialize
	
	C_OBJECT:C1216($esOutlineNumber)
	
	C_COLLECTION:C1488($cCaseSizeType)
	C_COLLECTION:C1488($cCaseSize)
	
	C_LONGINT:C283($nCount; $nTotal)
	
	C_TEXT:C284($tQuery)
	
	C_TEXT:C284($tStartDate; $tEndDate)
	
	C_TEXT:C284($tAtrbCaseSize)
	
	C_TEXT:C284($tCaseSize)
	
	ARRAY TEXT:C222($atCaseSize; 0)
	ARRAY TEXT:C222($atCount; 0)
	ARRAY TEXT:C222($atPercentage; 0)
	
	ARRAY LONGINT:C221($anCount; 0)
	
	ARRAY POINTER:C280($apColumn; 0)
	
	APPEND TO ARRAY:C911($apColumn; ->$atCaseSize)
	APPEND TO ARRAY:C911($apColumn; ->$atCount)
	APPEND TO ARRAY:C911($apColumn; ->$atPercentage)
	
	$esOutlineNumber:=New object:C1471()
	
	$cCaseSizeType:=New collection:C1472()
	$cCaseSize:=New collection:C1472()
	
	$tQuery:=CorektBlank
	
	$tStartDate:="2021-01-01"
	$tEndDate:="2021-04-01"
	
	$tAtrbCaseSize:="CaseSizeLWH"
	
	$tQuery:=$tQuery+"ModDate >= "+$tStartDate+" and "
	$tQuery:=$tQuery+"ModDate <= "+$tEndDate
	
End if   //Done initialize

$esOutlineNumber:=ds:C1482.Finished_Goods_PackingSpecs.query($tQuery)

$nTotal:=$esOutlineNumber.length

$cCaseSizeType:=$esOutlineNumber.distinct($tAtrbCaseSize)

$cCaseSize:=$esOutlineNumber.toCollection($tAtrbCaseSize)

For each ($tCaseSize; $cCaseSizeType)  //cGlueStyleType
	
	$nCount:=$cCaseSize.countValues($tCaseSize; $tAtrbCaseSize)
	
	APPEND TO ARRAY:C911($anCount; $nCount)  //Sort
	
	APPEND TO ARRAY:C911($atCaseSize; $tCaseSize)
	APPEND TO ARRAY:C911($atCount; String:C10($nCount))
	APPEND TO ARRAY:C911($atPercentage; String:C10(Round:C94(($nCount/$nTotal); 2)*100))
	
End for each   //Done cGlueStyleType

SORT ARRAY:C229($anCount; $atCaseSize; $atCount; $atPercentage; <)

APPEND TO ARRAY:C911($atCaseSize; "Total")
APPEND TO ARRAY:C911($atCount; String:C10($nTotal))
APPEND TO ARRAY:C911($atPercentage; "100")

Core_Array_ToDocument(->$apColumn)

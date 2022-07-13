//%attributes = {}
//Method:  JbIm_Rprt_GlueStyle
//Description:  This method will calculate Glue Styles

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($esGlueStyle)
	
	C_COLLECTION:C1488($cGlueStyleType)
	C_COLLECTION:C1488($cGlueStyle)
	
	C_TEXT:C284($tQuery)
	
	C_TEXT:C284($tStartDate; $tEndDate)
	
	C_TEXT:C284($tGlueStyle)
	C_TEXT:C284($tAtrbGlueStyle)
	
	C_LONGINT:C283($nCount; $nTotal)
	
	ARRAY TEXT:C222($atStyle; 0)
	ARRAY TEXT:C222($atCount; 0)
	ARRAY TEXT:C222($atPercentage; 0)
	
	ARRAY LONGINT:C221($anCount; 0)
	
	ARRAY POINTER:C280($apColumn; 0)
	
	APPEND TO ARRAY:C911($apColumn; ->$atStyle)
	APPEND TO ARRAY:C911($apColumn; ->$atCount)
	APPEND TO ARRAY:C911($apColumn; ->$atPercentage)
	
	$esGlueStyle:=New object:C1471()
	
	$cGlueStyleType:=New collection:C1472()
	$cGlueStyle:=New collection:C1472()
	
	$tQuery:=CorektBlank
	
	$tStartDate:="2021-01-01"
	$tEndDate:="2021-04-01"
	
	$tAtrbGlueStyle:="GlueStyle"
	
	$tQuery:=$tQuery+"Glued >= "+$tStartDate+" and "
	$tQuery:=$tQuery+"Glued <= "+$tEndDate
	
End if   //Done initialize

$esGlueStyle:=ds:C1482.Job_Forms_Items.query($tQuery)

$nTotal:=$esGlueStyle.length

$cGlueStyleType:=$esGlueStyle.distinct($tAtrbGlueStyle)

$cGlueStyle:=$esGlueStyle.toCollection($tAtrbGlueStyle)

For each ($tGlueStyle; $cGlueStyleType)  //cGlueStyleType
	
	$nCount:=$cGlueStyle.countValues($tGlueStyle; $tAtrbGlueStyle)
	
	APPEND TO ARRAY:C911($anCount; $nCount)  //Sort
	
	APPEND TO ARRAY:C911($atStyle; $tGlueStyle)
	APPEND TO ARRAY:C911($atCount; String:C10($nCount))
	APPEND TO ARRAY:C911($atPercentage; String:C10(Round:C94(($nCount/$nTotal); 2)*100))
	
End for each   //Done cGlueStyleType

SORT ARRAY:C229($anCount; $atStyle; $atCount; $atPercentage; <)

APPEND TO ARRAY:C911($atStyle; "Total")
APPEND TO ARRAY:C911($atCount; String:C10($nTotal))
APPEND TO ARRAY:C911($atPercentage; "100")

Core_Array_ToDocument(->$apColumn)

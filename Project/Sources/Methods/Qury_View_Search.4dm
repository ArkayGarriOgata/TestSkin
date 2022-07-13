//%attributes = {}
//Method:  Qury_View_Search(cQuery)
//Description:  This method will preform the query and set the current selection

If (True:C214)  //Initialize
	
	C_COLLECTION:C1488($1; $cQuery)
	
	C_OBJECT:C1216($esSearchTable)
	
	C_TEXT:C284($tTableName; $tQuery)
	
	$cQuery:=$1
	
	$tTableName:=Table name:C256($cQuery[0].nTableNumber)
	
	$esSearchTable:=New object:C1471()
	
End if   //Done initialize

$tQuery:=Core_Query_BuildT($cQuery)

$esSearchTable:=ds:C1482[$tTableName].query($tQuery)

ALERT:C41(String:C10($esSearchTable.length))

USE ENTITY SELECTION:C1513($esSearchTable)


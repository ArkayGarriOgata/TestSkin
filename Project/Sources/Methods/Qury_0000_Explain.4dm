//%attributes = {}
//Method:  Qury_0000_Explain
//Description:  This method will explain how the Qury module works.

//This is designed to work with saved 4D querys (.4df) or as a query replacement:

//When used as a saved 4D Query:
//  The field, comparator and conjuntion are just displayed.
//  it will only allow the end user to change values. Typically this is for date ranges.

//Example of {QueryName}.4df file after being parsed into an array and cleaned
//{
//"mainTable": 49,
//"queryDestination": 1,
//"version": 1,
//"lines": [
//{
//"tableNumber": "49",
//"fieldNumber": "20",
//"criterion": "7",
//"firstOfTwoBoxes": "6/1/17",
//"secondOfTwoBoxes": "1/31/18"
//},
//{
//"lineOperator": 1,
//"tableNumber": "49",
//"fieldNumber": "30",
//"criterion": "2",
//"oneBox": ""
//}
//]
//}

If (True:C214)
	
	C_COLLECTION:C1488($cQuery)
	
	C_OBJECT:C1216($oQueryDefined)
	
	$cQuery:=New collection:C1472()
	$oQueryDefined:=New object:C1471()
	
	QUERY:C277([Quick:85]; [Quick:85]Name:2="ArdenBookings")
	
	Qury_Parse4df(->[Quick:85]Query:8; $cQuery)
	
	OB SET:C1220($oQueryDefined; "cQuery"; $cQuery)
	
	Qury_Dialog_View($oQueryDefined)
	
End if 



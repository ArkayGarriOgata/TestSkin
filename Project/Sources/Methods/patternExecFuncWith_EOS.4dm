//%attributes = {"executedOnServer":true}
// _______
// Method: patternExecFuncWith_EOS   ( ) ->
// By: Mel Bohince @ 11/05/20, 18:58:02
// Description
// stub method for testing, test call from patternExecFuncOnServer
// NOTE THIS METHOD HAS ITS EXECUTE ON SERVER TURNED ON//
// ----------------------------------------------------

//passing the context_o is optional, use it if you need to pass in arguments
//in this example it is used for the query paramerters
C_OBJECT:C1216($1; $context)
If (Count parameters:C259>0)
	$context:=$1
Else   //for testing
	$context:=New object:C1471("PO"; "N6P@"; "dateBegin"; Add to date:C393(Current date:C33; 0; -1; 0); "dateEnd"; Current date:C33)
End if 

////////////////////////////begin sample "work"
//following is whatever your purpose is,
//in this example a text varible is created in csv format to make an Excel report

C_OBJECT:C1216($es; $entity)
C_COLLECTION:C1488($rows_c; $columns_c)
C_TEXT:C284($csvToExport; $fieldDelimitor; $recordDelimitor)
$csvToExport:=""
$fieldDelimitor:=","
$recordDelimitor:="\r"

$es:=ds:C1482.Customers_Invoices.query("CustomersPO = :1  and Invoice_Date >= :2 and Invoice_Date <= :3"; $context.PO; $context.dateBegin; $context.dateEnd).orderBy("InvoiceNumber")

$rows_c:=New collection:C1472  //there will be a row for each invoice 
//start with the column headings
$columns_c:=New collection:C1472
$columns_c.push("Invoice")
$columns_c.push("Date")
$columns_c.push("Type")
$rows_c.push($columns_c.join($fieldDelimitor))  //add the headers

//$context.status:="running"///optional

For each ($entity; $es)
	
	$columns_c:=New collection:C1472  //set up for the next row of date
	$columns_c.push(txt_ToCSV_attribute($entity; "InvoiceNumber"))
	$columns_c.push(txt_ToCSV_attribute($entity; "Invoice_Date"))
	$columns_c.push(txt_ToCSV_attribute($entity; "InvType"))
	
	$rows_c.push($columns_c.join($fieldDelimitor))  //add this row
	
End for each 

$csvToExport:=$rows_c.join($recordDelimitor)  //prep the text to send to file

//$context.status:="finished"///optional
////////////////////////////end sample "work"

//now pack the result to be sent back to the calling method
C_OBJECT:C1216($rtn_o)
$rtn_o:=New object:C1471("result"; $csvToExport)
C_TEXT:C284($0; $rtn_t)
$rtn_t:=JSON Stringify:C1217($rtn_o)  //intermediate $rtn_t used so the example below works when not called as a function
$0:=$rtn_t
//
//calling method would then unpack
//for example see patternExecFuncOnServer or below
C_TEXT:C284($result_json)
$result_json:=$rtn_t
C_OBJECT:C1216($result_o)
$result_o:=JSON Parse:C1218($result_json)
TEXT TO DOCUMENT:C1237("test.csv"; $result_o.result)



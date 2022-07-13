//%attributes = {}
// _______
// Method: util_EntitySelectionToCSV   ( es;columns;filename) ->
// By: MelvinBohince @ 06/21/22, 08:06:25
// Description
// 

// ex:
//C_COLLECTION($columns_c)
//$columns_c:=New collection  //specify the headers, could be done inline
//$columns_c.push("JobForm")
//$columns_c.push("Jobit")
//$columns_c.push("ProductCode")
//utilEntitySelectionToCSV($jobits_es;$columns_c)
// ----------------------------------------------------

C_OBJECT:C1216($entitySelection; $entity; $1)
C_COLLECTION:C1488($2; $rows_c; $columns_c)
C_TEXT:C284($csvToExport; $fieldDelimitor; $recordDelimitor; $fileName; $3)
$csvToExport:=""
$fieldDelimitor:=","
$recordDelimitor:="\r"

$rows_c:=New collection:C1472  //there will be a row for each invoice 
//start with the column headings

$entitySelection:=$1
$field_c:=$2
var $field : Text


If (Count parameters:C259>2)
	$fileName:=$3
Else 
	$fileName:="CSV_"
End if 

$rows_c.push($field_c.join($fieldDelimitor))  //add the headers

For each ($entity; $entitySelection)
	
	$columns_c:=New collection:C1472  //set up for the next row of date
	
	For each ($field; $field_c)
		$columns_c.push($entity[$field])
	End for each 
	
	$rows_c.push($columns_c.join($fieldDelimitor))  //add this row
	
End for each 

$csvToExport:=$rows_c.join($recordDelimitor)  //prep the text to send to file

util_SaveTextToDocument($fileName; ->$csvToExport)
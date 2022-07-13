// _______
// Method: [Finished_Goods_Locations].aMsWMS_Comparison.selectReport   ( ) ->
// By: Mel Bohince @ 11/12/20, 07:19:44
// Description
// send select to CSV file based on pattern_CSV_Export
// ----------------------------------------------------


C_OBJECT:C1216($es; $entity)
C_TEXT:C284($csvToExport; $fieldDelimitor; $recordDelimitor)
$csvToExport:=""
$fieldDelimitor:=","
$recordDelimitor:="\r"

C_COLLECTION:C1488($rows_c; $columns_c)
$rows_c:=New collection:C1472  //there will be a row for each invoice 
//start with the column headings
$columns_c:=New collection:C1472
$columns_c.push("CustID")
$columns_c.push("ProductCode")
$columns_c.push("Jobit")
$columns_c.push("Location")
$columns_c.push("aMs_Qty")
$columns_c.push("WMS_Qty")
$columns_c.push("Difference")
$columns_c.push("SortKey")
$rows_c.push($columns_c.join($fieldDelimitor))  //add the headers

C_OBJECT:C1216($row)
For each ($row; Form:C1466.selected)
	
	$columns_c:=New collection:C1472  //set up for the next row of date
	
	$columns_c.push(txt_ToCSV_attribute($row; "CustID"))
	$columns_c.push(txt_ToCSV_attribute($row; "ProductCode"))
	$columns_c.push(txt_ToCSV_attribute($row; "Jobit"))
	$columns_c.push(txt_ToCSV_attribute($row; "Location"))
	$columns_c.push(txt_ToCSV_attribute($row; "QtyOH"))
	$columns_c.push(txt_ToCSV_attribute($row; "WMSqty"))
	$columns_c.push(txt_ToCSV_attribute($row; "difference"))
	$columns_c.push(txt_ToCSV_attribute($row; "key"))
	
	$rows_c.push($columns_c.join($fieldDelimitor))  //add this row
	
End for each 

$csvToExport:=$rows_c.join($recordDelimitor)  //prep the text to send to file

//save the text to a document
C_TEXT:C284($docName)
C_TIME:C306($docRef)

$docName:="INVENTORY_BROWSER_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$docRef:=util_putFileName(->$docName)
CLOSE DOCUMENT:C267($docRef)

TEXT TO DOCUMENT:C1237(document; $csvToExport)
CLOSE DOCUMENT:C267($docRef)

uConfirm("CSV file saved to: "+document; "Thanks!!!"; "Why?")
If (ok=0)
	ALERT:C41("Just trying to help.")
End if 
$err:=util_Launch_External_App($docName)
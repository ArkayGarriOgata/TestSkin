//%attributes = {}
// _______
// Method: RML_PI_BeforeAfter_Rpt   ( ) ->
// By: Mel Bohince @ 12/22/21, 11:51:17
// Description
// 
// ----------------------------------------------------

// _______
// Method: RMX_PI_Tag_Rpt   ( ) ->
// By: Mel Bohince @ 12/20/21, 14:16:52
// Description
// 
// ----------------------------------------------------


C_TEXT:C284($docName; $docShortName)

$title:="Physical Inventory RM Before & After Report"

zwStatusMsg("RM PI"; "Before and after report Please wait...")

C_OBJECT:C1216($rml_e; $rml_es)
$rml_es:=ds:C1482.Raw_Materials_Locations.query("PiFreezeQty # :1"; 0).orderBy("Raw_Matl_Code,POItemKey")

If ($rml_es.length>0)
	//now build the report
	C_TEXT:C284($text; $fieldDelimitor; $recordDelimitor)
	$fieldDelimitor:=","
	$recordDelimitor:="\r"
	
	C_COLLECTION:C1488($rows_c; $columns_c)  //build each row so they can be joined at the end
	$rows_c:=New collection:C1472  //there will be a row for each transaction
	
	If (True:C214)  //start with the column headings  
		$columns_c:=New collection:C1472
		$columns_c.push("Location")
		$columns_c.push("POItemKey")
		$columns_c.push("Raw_Matl_Code")
		$columns_c.push("Commodity_Key")
		$columns_c.push("BeforeQty")
		$columns_c.push("AfterQty")
		$columns_c.push("ActCost(unit)")
		$columns_c.push("ValueChange")
		
		$rows_c.push($columns_c.join($fieldDelimitor))  //add the headers
	End if   //headings
	
	For each ($rml_e; $rml_es)
		
		$columns_c:=New collection:C1472
		$columns_c.push($rml_e.Location)
		$columns_c.push($rml_e.POItemKey)
		$columns_c.push($rml_e.Raw_Matl_Code)
		$columns_c.push($rml_e.Commodity_Key)
		$columns_c.push(String:C10($rml_e.PiFreezeQty))
		$columns_c.push(String:C10($rml_e.QtyOH))
		$qtyChange:=$rml_e.QtyOH-$rml_e.PiFreezeQty
		$columns_c.push(String:C10(Round:C94($rml_e.ActCost; 4)))
		$columns_c.push(String:C10(Round:C94($rml_e.ActCost*$qtyChange; 2)))
		
		$rows_c.push($columns_c.join($fieldDelimitor))  //add this row
		
	End for each 
	
	$text:=$rows_c.join($recordDelimitor)  //prep the text to send to file $0:=$csvText
	
Else 
	$text:="No PI Freeze quantities found."
	ALERT:C41($text)
End if 

zwStatusMsg("RM PI"; "Before and after report finished.")

$text:=$text+"\r\r"+$title+"\r\r------ END OF FILE ------"  // add some distance so excel has room for totals

$docName:="RM_BEFORE_AFTER_RPT_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$docShortName:=$docName  //capture before path is prepended
C_TIME:C306($docRef)
$docRef:=util_putFileName(->$docName)
CLOSE DOCUMENT:C267($docRef)

TEXT TO DOCUMENT:C1237(document; $text)

$err:=util_Launch_External_App($docName)

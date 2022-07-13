//%attributes = {}
// _______
// Method: FGL_PI_BeforeAfter_Rpt   ( ) ->
// By: Mel Bohince @ 12/22/21, 11:51:17
// Description
// 
// ----------------------------------------------------


C_TEXT:C284($docName; $docShortName)
CONFIRM:C162("Label this report?"; "Before"; "After")
If (ok=1)
	$which:="Before"
Else 
	$which:="After"
End if 
$title:="Physical Inventory FG "+$which+" Report"

zwStatusMsg("FGM PI"; "Before and after report Please wait...")
//[Finished_Goods_Locations]ProductCode
C_OBJECT:C1216($fgl_e; $fgl_es)
$fgl_es:=ds:C1482.Finished_Goods_Locations.all().orderBy("Jobit,Location")

If ($fgl_es.length>0)
	//now build the report
	C_TEXT:C284($text; $fieldDelimitor; $recordDelimitor)
	$fieldDelimitor:=","
	$recordDelimitor:="\r"
	
	C_COLLECTION:C1488($rows_c; $columns_c)  //build each row so they can be joined at the end
	$rows_c:=New collection:C1472  //there will be a row for each transaction
	
	If (True:C214)  //start with the column headings  
		$columns_c:=New collection:C1472
		$columns_c.push("ProductCode")
		$columns_c.push("Jobit")
		$columns_c.push("Location")
		$columns_c.push("LookupKey")
		$columns_c.push("Qty_"+$which)
		//$columns_c.push("ActCost(unit)")
		//$columns_c.push("ValueChange")
		
		$rows_c.push($columns_c.join($fieldDelimitor))  //add the headers
	End if   //headings
	
	For each ($fgl_e; $fgl_es)
		
		$columns_c:=New collection:C1472
		$columns_c.push($fgl_e.ProductCode)
		$columns_c.push($fgl_e.Jobit)
		$columns_c.push($fgl_e.Location)
		$columns_c.push($fgl_e.Jobit+$fgl_e.Location)
		$columns_c.push(String:C10($fgl_e.QtyOH))
		
		$rows_c.push($columns_c.join($fieldDelimitor))  //add this row
		
	End for each 
	
	$text:=$rows_c.join($recordDelimitor)  //prep the text to send to file $0:=$csvText
	
Else 
	$text:="No PI Freeze quantities found."
	ALERT:C41($text)
End if 

zwStatusMsg("RM PI"; "Before and after report finished.")

$text:=$text+"\r\r"+$title+"\r\r------ END OF FILE ------"  // add some distance so excel has room for totals

$docName:="FG_"+$which+"_RPT_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$docShortName:=$docName  //capture before path is prepended
C_TIME:C306($docRef)
$docRef:=util_putFileName(->$docName)
CLOSE DOCUMENT:C267($docRef)

TEXT TO DOCUMENT:C1237(document; $text)

$err:=util_Launch_External_App($docName)

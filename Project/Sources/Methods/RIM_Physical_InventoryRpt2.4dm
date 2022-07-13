//%attributes = {}
// _______
// Method: RIM_Physical_InventoryRpt2   ( ) ->
// By: Mel Bohince @ 11/15/21, 13:50:56
// Description
// 
// ----------------------------------------------------

//READ ONLY([Raw_Materials_Locations])
//READ ONLY([Raw_Material_Labels])
//[Raw_Material_Labels]POItemKey



If (True:C214)  //define the column and row structure and add the column labels
	C_TEXT:C284($csvToExport; $fieldDelimitor; $recordDelimitor)
	$csvToExport:=""  //this is the the text of the outputted file
	$fieldDelimitor:=","  //csv
	$recordDelimitor:="\r"
	
	C_COLLECTION:C1488($rows_c; $columns_c)
	$rows_c:=New collection:C1472  //there will be a row for the rm and each of its open po's or open allocations 
	//start with the column headings
	$columns_c:=New collection:C1472
	$columns_c.push("Commodity")
	$columns_c.push("RawMaterialCode")
	$columns_c.push("POItem")
	$columns_c.push("Warehouse")
	$columns_c.push("QtyOH")
	$columns_c.push("ROLLS")
	$columns_c.push("QtyROLLS")
	$columns_c.push("Difference")
	For ($i; 1; 40)
		$columns_c.push("Roll"+String:C10($i; "00"))
		$columns_c.push("Qty"+String:C10($i; "00"))
		$columns_c.push("Loc"+String:C10($i; "00"))
	End for 
	
	$rows_c.push($columns_c.join($fieldDelimitor))  //add the headers
End if 

C_OBJECT:C1216($labels_es; $locations_es; $location_e)
C_COLLECTION:C1488($labelPOs_c)
ARRAY TEXT:C222($_POItemKey; 0)

//put the labels' po's in a collection to find their location records
$labels_es:=ds:C1482.Raw_Material_Labels.query("Qty > :1"; 0).orderBy("Label_id")

C_COLLECTION:C1488($labelPOs_c)
$labelPOs_c:=$labels_es.toCollection("POItemKey")

//strip the property names from the collection
COLLECTION TO ARRAY:C1562($labelPOs_c; $_POItemKey; "POItemKey")
ARRAY TO COLLECTION:C1563($labelPOs_c; $_POItemKey)

//[Raw_Materials_Locations] that have labels
$locations_es:=ds:C1482.Raw_Materials_Locations.query("POItemKey in :1"; $labelPOs_c).orderBy("Raw_Matl_Code")

For each ($location_e; $locations_es)
	//there will be a row for the rm and each of its open po's or open allocations 
	//start with the column headings
	$columns_c:=New collection:C1472
	$columns_c.push($location_e.Commodity_Key)
	$columns_c.push($location_e.Raw_Matl_Code)
	$columns_c.push("'"+$location_e.POItemKey)
	$columns_c.push($location_e.Location)
	$columns_c.push(txt_quote(String:C10($location_e.QtyOH; "###,###,###")))
	
	$labelPOs_es:=$labels_es.query("RM_Location_fk =:1"; $location_e.pk_id).orderBy("Label_id")
	
	$columns_c.push(String:C10($labelPOs_es.length))
	$rollQty:=$labelPOs_es.sum("Qty")
	$columns_c.push(txt_quote(String:C10($rollQty; "###,###,###")))
	$columns_c.push(txt_quote(String:C10($location_e.QtyOH-$rollQty; "###,###,###")))
	
	For each ($label_e; $labelPOs_es)
		$columns_c.push($label_e.Label_id)
		$columns_c.push(txt_quote(String:C10($label_e.Qty; "###,###,###")))
		$columns_c.push($label_e.Location)
	End for each 
	
	$rows_c.push($columns_c.join($fieldDelimitor))
	
End for each   //location

If ($rows_c.length>1)
	$csvToExport:=$rows_c.join($recordDelimitor)  //prep the text to send to file
Else 
	$csvToExport:="No ' "+"Rolls"+" ' found."
End if 

$docName:="RollStockInventory_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(Current time:C178; HH MM SS:K7:1); ":"; "")+".csv"
$docShortName:=$docName  //capture before path is prepended
$docRef:=util_putFileName(->$docName)
CLOSE DOCUMENT:C267($docRef)

TEXT TO DOCUMENT:C1237($docName; $csvToExport)

$err:=util_Launch_External_App($docName)





If (True:C214)  //dump all the roll labels for walkaround report
	$csvToExport:=""  //this is the the text of the outputted file
	$rows_c:=New collection:C1472  //there will be a row for the rm and each of its open po's or open allocations 
	//start with the column headings
	$columns_c:=New collection:C1472
	$columns_c.push("Label_id")
	$columns_c.push("Raw_Matl_Code")
	$columns_c.push("POItemKey")
	$columns_c.push("Qty")
	$columns_c.push("Warehouse")
	$columns_c.push("Location")
	
	$rows_c.push($columns_c.join($fieldDelimitor))  //add the headers
End if 

For each ($label_e; $labels_es)
	
	$columns_c:=New collection:C1472
	$columns_c.push($label_e.Label_id)
	$columns_c.push($label_e.Raw_Matl_Code)
	$columns_c.push("'"+$label_e.POItemKey)
	$columns_c.push(txt_quote(String:C10($label_e.Qty; "###,###")))
	If ($label_e.RM_Legacy_Location#Null:C1517)
		$columns_c.push($label_e.RM_Legacy_Location.Location)
	Else 
		$columns_c.push("ORPHAN-NO-LINK")
	End if 
	$columns_c.push($label_e.Location)
	
	$rows_c.push($columns_c.join($fieldDelimitor))  //add the headers
	
End for each 

If ($rows_c.length>1)
	$csvToExport:=$rows_c.join($recordDelimitor)  //prep the text to send to file
Else 
	$csvToExport:="No ' "+"Rolls"+" ' found."
End if 

$docName:="RollStockLabels_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(Current time:C178; HH MM SS:K7:1); ":"; "")+".csv"
$docShortName:=$docName  //capture before path is prepended
$docRef:=util_putFileName(->$docName)
CLOSE DOCUMENT:C267($docRef)

TEXT TO DOCUMENT:C1237($docName; $csvToExport)

$err:=util_Launch_External_App($docName)
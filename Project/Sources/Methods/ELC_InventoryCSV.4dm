//%attributes = {}
// _______
// Method: ELC_InventoryCSV   ( ) ->
// By: Mel Bohince @ 08/31/20, 11:37:43
// Description
// send csv of inventory by lot to ELC
// ----------------------------------------------------


C_LONGINT:C283($1; $pid)  //singleton

If (Count parameters:C259=0)  //fire up new process
	$pid:=New process:C317(Current method name:C684; 0; Current method name:C684; 1; *)
	SHOW PROCESS:C325($pid)
	
Else   //do the deed
	C_COLLECTION:C1488($rows_c; $columns_c)
	C_TEXT:C284($csvToExport; $fieldDelimitor; $recordDelimitor)
	$csvToExport:=""
	$fieldDelimitor:=","
	$recordDelimitor:="\r"
	C_DATE:C307($glueDate)
	C_BOOLEAN:C305($showExtra)  //show destinations and CustomerRefers
	$showExtra:=False:C215
	/////////////////////
	//here's your overview of what the csv will look like:
	//define the columns that will be exported
	$rows_c:=New collection:C1472  //there will be a row for each invoice 
	//start with the column headings
	//product_lineproduct_codedescriptionpacking_spec qty_onhand  qty_certification  qty_wip  qty_open_order  qty_scheduled historic_orderslast_update
	$columns_c:=New collection:C1472
	$columns_c.push("Item")
	$columns_c.push("Line")
	$columns_c.push("Description")
	$columns_c.push("PackingSpec")
	$columns_c.push("On-hand")
	$columns_c.push("Certification")
	$columns_c.push("WIP")
	$columns_c.push("OpenOrder")
	$columns_c.push("OpenRelease")
	//If ($showExtra)
	//$columns_c.push("Destinations")
	//$columns_c.push("PurchaseOrders")
	//End if 
	$rows_c.push($columns_c.join($fieldDelimitor))  //add the headers
	
	//set up the arrays for each column, 
	ARRAY TEXT:C222($_product_line; 0)
	ARRAY TEXT:C222($_product_code; 0)
	ARRAY TEXT:C222($_description; 0)
	ARRAY TEXT:C222($_packing_spec; 0)
	ARRAY LONGINT:C221($_qty_onhand; 0)
	ARRAY LONGINT:C221($_qty_certification; 0)
	ARRAY LONGINT:C221($_qty_wip; 0)
	ARRAY LONGINT:C221($_qty_open_order; 0)
	ARRAY LONGINT:C221($_qty_scheduled; 0)
	//If ($showExtra)
	//ARRAY TEXT($_Destinations;0)
	//ARRAY TEXT($_PurchaseOrders;0)
	//End if 
	
	Begin SQL
		select product_line,product_code,description,packing_spec,qty_onhand,qty_certification,qty_wip,qty_open_order,qty_scheduled 
		from Portal_ItemMaster 
		where AccessID = 'A450D65F1C8F4609BF3518ACB0247172'
		order by product_line, product_code
		into :$_product_line,:$_product_code,:$_description,:$_packing_spec,:$_qty_onhand,:$_qty_certification,:$_qty_wip,:$_qty_open_order,:$_qty_scheduled
	End SQL
	
	/////////////////////
	//convert arrays to text that can be saved to disk
	If (Size of array:C274($_product_line)>0)  //something to report
		
		For ($i; 1; Size of array:C274($_product_line))  //build each row by its columns
			$columns_c:=New collection:C1472  //set up for the next row of date
			$columns_c.push(txt_ToCSV(->$_product_line{$i}))
			$columns_c.push(txt_ToCSV(->$_product_code{$i}))
			$columns_c.push(txt_ToCSV(->$_description{$i}))
			$columns_c.push(txt_ToCSV(->$_packing_spec{$i}))
			$columns_c.push(txt_ToCSV(->$_qty_onhand{$i}))
			$columns_c.push(txt_ToCSV(->$_qty_certification{$i}))
			$columns_c.push(txt_ToCSV(->$_qty_wip{$i}))
			$columns_c.push(txt_ToCSV(->$_qty_open_order{$i}))
			$columns_c.push(txt_ToCSV(->$_qty_scheduled{$i}))
			//If ($showExtra)
			//$columns_c.push(txt_ToCSV (->$_Destinations{$i}))
			//$columns_c.push(txt_ToCSV (->$_PurchaseOrders{$i}))
			//End if 
			$rows_c.push($columns_c.join($fieldDelimitor))  //add this row
			
		End for 
		
	Else   //nothing qualified
		$columns_c:=New collection:C1472
		$columns_c.push("No qualifying inventory found")
		$rows_c.push($columns_c.join($fieldDelimitor))  //add this row
	End if 
	
	$csvToExport:=$rows_c.join($recordDelimitor)  //prep the text to send to file
	
	/////////////////////
	//save the text to a document
	If (Length:C16($csvToExport)>0)
		C_TEXT:C284($docName)
		C_TIME:C306($docRef)
		
		$docName:="ELC_PortalItemMaster_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
		$docRef:=util_putFileName(->$docName)
		CLOSE DOCUMENT:C267($docRef)
		
		TEXT TO DOCUMENT:C1237(document; $csvToExport)
		CLOSE DOCUMENT:C267($docRef)
		
		$distributionList:=Batch_GetDistributionList("ELC Inventory")
		$subject:="ELC Inventory for "+String:C10(Current date:C33; System date short:K1:1)
		$preheader:="Attached CSV file of the Arkay Portal information."
		$body:="Please see the attached CSV file with Line, Item, Description, Packing Spec, and inventory counts for ELC items at Arkay Packaging."
		Email_html_body($subject; $preheader; $body; 500; $distributionList; $docName)  //far too confusing to mgmt to summarize data
		util_deleteDocument($docName)
		//  $err:=util_Launch_External_App ($docName)
	End if 
End if   //new process


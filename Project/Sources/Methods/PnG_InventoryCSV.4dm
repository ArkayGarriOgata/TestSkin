//%attributes = {}
// _______
// Method: PnG_InventoryCSV   ( ) ->
// By: Mel Bohince @ 08/25/20, 15:53:19
// Description
// send csv of inventory by lot to PnG
// ----------------------------------------------------
// Modified by: Mel Bohince (8/28/20) include FG:x_SHIP locations

C_LONGINT:C283($1; $pid)  //singleton

If (Count parameters:C259=0)  //fire up new process
	$pid:=New process:C317(Current method name:C684; 0; Current method name:C684; 1; *)
	SHOW PROCESS:C325($pid)
	
Else   //do the deed
	C_OBJECT:C1216($es; $entity)
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
	$columns_c:=New collection:C1472
	$columns_c.push("PlantID")
	$columns_c.push("Item")
	$columns_c.push("Line")
	$columns_c.push("Description")
	$columns_c.push("LotNumber")
	$columns_c.push("FirstGlued")
	$columns_c.push("Age(Days)")
	$columns_c.push("Inventory@Arkay(Units)")
	$columns_c.push("PricePer1000")
	$columns_c.push("Inventory@Arkay($)")
	If ($showExtra)
		$columns_c.push("Destinations")
		$columns_c.push("PurchaseOrders")
	End if 
	$rows_c.push($columns_c.join($fieldDelimitor))  //add the headers
	
	//set up the arrays for each column, 
	//   the fg_location data is many (locations and Jobits)
	//   to one for each productcode, so they will need rolled up
	ARRAY TEXT:C222($_PlantID; 0)
	ARRAY TEXT:C222($_Line; 0)
	ARRAY TEXT:C222($_Item; 0)
	ARRAY TEXT:C222($_Description; 0)
	ARRAY TEXT:C222($_LotNumber; 0)
	ARRAY DATE:C224($_FirstGlued; 0)
	ARRAY LONGINT:C221($_Days; 0)
	ARRAY LONGINT:C221($_Units; 0)
	ARRAY REAL:C219($_UnitPrice; 0)
	ARRAY REAL:C219($_Value; 0)
	If ($showExtra)
		ARRAY TEXT:C222($_Destinations; 0)
		ARRAY TEXT:C222($_PurchaseOrders; 0)
	End if 
	
	/////////////////////
	//find the qualifying locations
	//
	// setup filter to APDO and Skin Care only based on po
	//get a collection to be used in fgl entity query
	If (False:C215)  //targets are ordered under 2 blanket po's
		
		ARRAY TEXT:C222($_TargetProductCodes; 0)
		C_COLLECTION:C1488($_TargetProductCodes_c)
		$_TargetProductCodes_c:=New collection:C1472
		
		If (False:C215)  //sql way:
			Begin SQL
				select ProductCode from Customers_Order_Lines 
				where PONumber = 'N6P-5500016993' or PONumber = 'N6P-5500020453'
				into :$_TargetProductCodes
			End SQL
			ARRAY TO COLLECTION:C1563($_TargetProductCodes_c; $_TargetProductCodes)
			
		Else   //orda way:
			
			$_TargetProductCodes_c:=ds:C1482.Customers_Order_Lines.query("PONumber = :1 or PONumber = :2"; "N6P-5500016993"; "N6P-5500020453").toCollection("ProductCode")
			COLLECTION TO ARRAY:C1562($_TargetProductCodes_c; $_TargetProductCodes; "ProductCode")  //strip the attribute name
			ARRAY TO COLLECTION:C1563($_TargetProductCodes_c; $_TargetProductCodes)  //re-build as a simple collection w/o attribute name
		End if   //sql v orda
		//
		//use the collection from above as a parameter for the IN clause
		$es:=ds:C1482.Finished_Goods_Locations.query("CustID = :1 and ProductCode IN :2"; "00199"; $_TargetProductCodes_c).orderBy("ProductCode, Jobit")  //filtered PnG items
		
	End if   //false -- filtering by PO
	
	/////////////////////
	//all PnG inventory, kill them all, let god sort it out
	$es:=ds:C1482.Finished_Goods_Locations.query("CustID = :1"; "00199").orderBy("ProductCode, Jobit")  //all PnG locations for testing
	
	For each ($entity; $es)
		//filter or tally
		Case of 
				//: (Position("ship";$entity.Location)>0)  //skip, assume gone     // Modified by: Mel Bohince (8/28/20) include FG:x_SHIP locations
				//utl_Logfile ("BatchRunner.Log";"PnG_Inventory "+$entity.ProductCode+" FG staging")
			: (Position:C15("lost"; $entity.Location)>0)  //skip, assume MIA
				utl_Logfile("PnG_InventoryCSV.Log"; "PnG_Inventory "+$entity.ProductCode+" FG lost")
			: ($entity.PRODUCT_CODE=Null:C1517)  //skip, line and desc will be blank
				utl_Logfile("PnG_InventoryCSV.Log"; "PnG_Inventory "+$entity.ProductCode+" FG rec n/f")
				//:(Find in array($_TargetProductCodes;$entity.ProductCode)=-1)//skip, if using brute force, not interested in anything but APDO and Skin Care
			Else 
				$hit:=Find in array:C230($_LotNumber; $entity.Jobit)
				If ($hit=-1)  //add the jobit
					$hit:=Size of array:C274($_Item)+1  //move cursor to the end
					APPEND TO ARRAY:C911($_PlantID; "1707")  //their code for Brown Summit
					APPEND TO ARRAY:C911($_Item; $entity.ProductCode)
					APPEND TO ARRAY:C911($_Line; $entity.PRODUCT_CODE.Line_Brand)
					APPEND TO ARRAY:C911($_Description; $entity.PRODUCT_CODE.CartonDesc)
					APPEND TO ARRAY:C911($_LotNumber; $entity.Jobit)
					$glueDate:=JMI_getGlueDate($entity.Jobit)
					APPEND TO ARRAY:C911($_FirstGlued; $glueDate)
					APPEND TO ARRAY:C911($_Days; (Current date:C33-$glueDate))
					APPEND TO ARRAY:C911($_Units; $entity.QtyOH)
					APPEND TO ARRAY:C911($_UnitPrice; FG_getLastPrice($entity.FG_Key))
					APPEND TO ARRAY:C911($_Value; Round:C94($_UnitPrice{$hit}*$_Units{$hit}/1000; 2))
					
					If ($showExtra)
						C_OBJECT:C1216($rel_es)
						C_TEXT:C284($po_t; $addrID; $destinations_t)
						$rel_es:=ds:C1482.Customers_ReleaseSchedules.query("ProductCode = :1 and Actual_Date = :2"; $entity.ProductCode; !00-00-00!)
						If ($rel_es.length>0)
							C_COLLECTION:C1488($shiptos_c; $destinations_c; $po_c)
							$po_c:=$rel_es.distinct("CustomerRefer")
							$po_t:=$po_c.join("*")
							$shiptos_c:=$rel_es.distinct("Shipto")
							$destinations_c:=New collection:C1472
							For each ($addrID; $shiptos_c)
								$destinations_c.push($addrID+"-"+ADDR_getCity($addrID))
							End for each 
							$destinations_t:=$destinations_c.join("*")
							APPEND TO ARRAY:C911($_Destinations; $destinations_t)
							APPEND TO ARRAY:C911($_PurchaseOrders; $po_t)
						Else 
							APPEND TO ARRAY:C911($_Destinations; "no open releases")
							APPEND TO ARRAY:C911($_PurchaseOrders; "-")
						End if 
					End if 
					
					
				Else   //increment
					$_Units{$hit}:=$_Units{$hit}+$entity.QtyOH
					$_Value{$hit}:=Round:C94($_UnitPrice{$hit}*$_Units{$hit}/1000; 2)
				End if 
				
		End case 
	End for each 
	
	/////////////////////
	//convert arrays to text that can be saved to disk
	If (Size of array:C274($_Item)>0)  //something to report
		
		For ($i; 1; Size of array:C274($_Item))  //build each row by its columns
			$columns_c:=New collection:C1472  //set up for the next row of date
			$columns_c.push(txt_ToCSV(->$_PlantID{$i}))
			$columns_c.push(txt_ToCSV(->$_Item{$i}))
			$columns_c.push(txt_ToCSV(->$_Line{$i}))
			$columns_c.push(txt_ToCSV(->$_Description{$i}))
			$columns_c.push(txt_ToCSV(->$_LotNumber{$i}))
			$columns_c.push(txt_ToCSV(->$_FirstGlued{$i}))
			$columns_c.push(txt_ToCSV(->$_Days{$i}))
			$columns_c.push(txt_ToCSV(->$_Units{$i}))
			$columns_c.push(txt_ToCSV(->$_UnitPrice{$i}))
			$columns_c.push(txt_ToCSV(->$_Value{$i}))
			If ($showExtra)
				$columns_c.push(txt_ToCSV(->$_Destinations{$i}))
				$columns_c.push(txt_ToCSV(->$_PurchaseOrders{$i}))
			End if 
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
		
		$docName:="PnG_Arkay_Inv_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
		$docRef:=util_putFileName(->$docName)
		CLOSE DOCUMENT:C267($docRef)
		
		TEXT TO DOCUMENT:C1237(document; $csvToExport)
		CLOSE DOCUMENT:C267($docRef)
		
		$distributionList:=Batch_GetDistributionList("PnG Inventory")
		$subject:="PnG Inventory for "+String:C10(Current date:C33; System date short:K1:1)
		$preheader:="Attached CSV file of inventory by lot number"
		$body:="Please see the attached CSV file with PlantID, Item, Line, Description, Lot#, Glue Date, Quantity, Unit price and Total Value for P&G items currently warehoused at Arkay Packaging."
		Email_html_body($subject; $preheader; $body; 500; $distributionList; $docName)  //far too confusing to mgmt to summarize data
		util_deleteDocument($docName)
		//$err:=util_Launch_External_App ($docName)
	End if 
End if   //new process


//%attributes = {}
// _______
// Method: OWC_API   ( ) ->
// By: Angelo @ 10/15/19, 15:44:42
// Description
// 
// ----------------------------------------------------

// OWC_API 

// This method handles all requests that begin with /api/
// It is a JSON REST API that handles CRUD operations (Create, Retrieve, Update, Delete)
// Each CRUD operation depends on the HTTP verb that is used like this:
// To perform any operation on a record you must pass the following URL
// https://www.domain.com/api/TABLE(PK)?url=params
// Create: PUT
// Retrieve: GET
// Update: POST
// Delete: DELETE

//Examples of use:
//CREATE AN ENTITY: PUT /api/TABLE {body in json format}
//RETRIEVE AN ENTITY: GET /api/TABLE(PK)
//UPDATE AN ENTITY: POST /api/TABLE(PK) {body in json format}
//DELETE AN ENTITY: DELETE /api/TABLE(PK)
//LIST A TABLE: GET /api/TABLE
//QUERY A TABLE: GET /api/TABLE?q=Criteria

//Specific examples
//QUERY PRODUCTS WITH PRICE LESS THAN 8: GET /api/PRODUCTS?q=(Unit_Price < 8)
//GET CUSTOMER WITH ID=22  AND HIS/HER INVOICES: GET /api/CUSTOMERS(22)?rel_N=invoicesList
//GET INVOICE MA000456 ITS CUSTOMER, INVOICE LINES AND THEIR PRODUCTS: GET /api/INVOICES(MA000456)?rel_N=lines&rel_1=customerDetail&rel_N_1=product


C_TEXT:C284($1; $2; $search; $pk; $table; $attribs)
C_LONGINT:C283($offset; $limit; $pos1; $pos2; $pos3)
C_OBJECT:C1216($obResp; $selEnts; $status; $tableInfo; $entity)
C_COLLECTION:C1488(colPublishedTables; $colTables)

// Check if the URL contains parentheses in order to know if the request is for a record or a table
$pos1:=Position:C15("("; $1)
$pos2:=Position:C15(")"; $1)

// Extract the name of the table from the URL
$lenAPI:=Length:C16("api/")+1
$pos3:=Position:C15("?"; $1)-$lenAPI+1
If ($pos1>0)
	$table:=Substring:C12($1; $lenAPI; $pos1-$lenAPI)
Else 
	$table:=Substring:C12($1; $lenAPI)
End if 

If ($pos3>0)
	$table:=Substring:C12($table; 1; $pos3-1)
End if 

$table:=Replace string:C233($table; "/"; "")


// Get list of published tables and fields
If (colPublishedTables.length=0)
	colPublishedTables:=API_Load_Tables
End if 

$colTables:=colPublishedTables.query("tableName == :1"; $table)

If ($colTables.length=1)
	$tableInfo:=$colTables[0]
	$table:=$tableInfo.tableName
	$attribs:=$tableInfo.fields.query("publish = :1"; True:C214).extract("fieldName").join(",")
End if 

// Get PK of the record
If (($pos3>0) & (($pos3+$lenAPI+1)>$pos2)) | ($pos3<=0)
	$pk:=Substring:C12($1; $pos1+1; $pos2-$pos1-1)
	
	// Get entity from primary key
	If (ds:C1482[$table]#Null:C1517) & ($pk#"")
		$entity:=ds:C1482[$table].get($pk)
	End if 
	
Else 
	$entity:=Null:C1517
End if 

// Define the operation according to the HTTP verb and if the operation is on a record or a table
Case of 
		
	: ($colTables.length=0)
		HTTP_SET_HEADER("X-status"; "404")  // ERROR: table not found
		WEB_RESP_JSON("Table "+$table+" not found")
		
		
	: ($tableInfo.publish=False:C215)
		HTTP_SET_HEADER("X-status"; "404")  // ERROR: table not published
		WEB_RESP_JSON("Table "+$table+" not published"; 4)
		
	: ($pk#"") & ($entity=Null:C1517)  // Entity not found
		HTTP_SET_HEADER("X-status"; "404")  // ERROR: Entity not found
		WEB_RESP_JSON("Entity not found"; 5)
		
		
	: ($2="PUT@")  // CREATE
		$entity:=ds:C1482[$table].new()
		WEB_JSON_TO_ENTITY($entity)
		WEB_SEND_ENTITY($entity; $attribs)
		
	: ($2="GET@") & ($entity#Null:C1517)  // RETRIEVE
		WEB_SEND_ENTITY($entity; $attribs)
		
	: ($2="POST@") & ($entity#Null:C1517)  // UPDATE
		WEB_JSON_TO_ENTITY($entity)
		WEB_SEND_ENTITY($entity; $attribs)
		
	: ($2="DELETE@") & ($entity#Null:C1517)  // DELETE
		$status:=$entity.drop()
		
		If ($status.success)
			WEB_RESP_JSON("The record was deleted"; 3)
		Else 
			WEB_RESP_JSON("ERROR when deleting: "; $status.statusText)
		End if 
		
	: ($2="GET@")  // LIST TABLE
		$obVars:=WEB_Get_Vars
		$search:=$obVars.q  // Get query string
		$offset:=Choose:C955($obVars.offset#Null:C1517; Num:C11($obVars.offset); 0)  // Get offset, i.e. return list starting from position offset
		$limit:=Choose:C955($obVars.limit#Null:C1517; Num:C11($obVars.limit); 20)  // Get limit, i.e. number of items to return
		
		//TODO, this should be inthe tables.json file
		C_TEXT:C284($sortCriteria; $searchCriteria)
		Case of 
			: ($table="ProductionSchedules")
				$sortCriteria:="Completed asc, CostCenter asc, Priority asc, StartDate asc, StartTime asc"
				$searchCriteria:="(Priority > 0) and (Priority < 101)"  // and (Completed = 0)"
				
			: ($table="Customers_ReleaseSchedules")
				$sortCriteria:="Sched_Date asc, Shipto asc"
				$searchCriteria:="(OpenQty > 0) and (THC_State = 0) and (CustomerRefer # "+txt_quote("@FORECAST@")+")"
				
			: ($table="Job_Forms")
				$sortCriteria:="JobFormID asc"
				$searchCriteria:="(Status = "+txt_quote("WIP")+")"
				
			: ($table="Job_Forms_Items")
				$sortCriteria:="Gluer asc, Priority asc"
				$searchCriteria:="(Priority > 0) and (Priority < 101) and Qty_Actual = 0"
				
			Else 
				$sortCriteria:=""
				$searchCriteria:=""
		End case 
		
		If ($search#"")
			ON ERR CALL:C155("API_ERR")  // Handle errors with API_ERR method, in case the query string is not valid
			
			Case of 
				: (Length:C16($searchCriteria)>0)
					$search:=$search+" and "+$searchCriteria
				Else 
					
			End case 
			
			If (Length:C16($sortCriteria)>0)
				$selEnts:=ds:C1482[$table].query($search).orderBy($sortCriteria)
			Else 
				$selEnts:=ds:C1482[$table].query($search)
			End if 
			ON ERR CALL:C155("")
		Else 
			
			
			Case of 
				: (Length:C16($searchCriteria)>0) & (Length:C16($sortCriteria)>0)  //($table="ProductionSchedules")
					$selEnts:=ds:C1482[$table].query($searchCriteria).orderBy($sortCriteria)
					
				Else 
					$selEnts:=ds:C1482[$table].all()  //original code
			End case 
		End if 
		
		$total:=$selEnts.length
		
		If (($offset+$limit)>$total)
			$offset:=0
		End if 
		
		If ($total>=$offset) & (False:C215)  //for debugging 
			$selEnts:=$selEnts.slice($offset; $offset+$limit)
		End if 
		
		$stats:=New object:C1471("total"; $total; "offset"; $offset; "limit"; $limit; "length"; $selEnts.length)
		WEB_SEND_LIST($selEnts; $attribs; $stats)
		
		
	Else 
		HTTP_SET_HEADER("X-status"; "404")
		WEB_RESP_JSON("Wrong request"; 6)
End case 

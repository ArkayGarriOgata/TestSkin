//%attributes = {}
// Method: pattern_CSV_Export
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 05/13/20, 11:30:28
// ----------------------------------------------------
// Description
// Added by: Mel Bohince (6/24/20) sample using collections to join columns and rows
// Modified by: Mel Bohince (8/27/20) adapt to changes made in txt_ToCSV's argument types

If (True:C214)  //using utility method
	var $en : Object
	$es:=ds:C1482.Customers_Invoices.query("InvType = :1  and Invoice_Date > :2"; "debit"; !2021-05-01!).orderBy("InvoiceNumber").orderBy("BillTo")
	
	var $columns_c : Collection
	$columns_c:=New collection:C1472
	$columns_c.push("InvoiceNumber")
	$columns_c.push("Invoice_Date")
	
	util_EntitySelectionToCSV($es; $columns_c)
End if 
C_OBJECT:C1216($es; $entity)
C_TEXT:C284($csvToExport; $fieldDelimitor; $recordDelimitor)
$csvToExport:=""
$fieldDelimitor:=","
$recordDelimitor:="\r"

$es:=ds:C1482.Customers_Invoices.query("Invoice_Date = :1"; !2022-05-09!).orderBy("InvoiceNumber")
C_COLLECTION:C1488($invoice_c)
$invoice_c:=$es.toCollection()


If (False:C215)  //time honored method, works great, hard to maintain
	
	QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]CustomersPO:11="N6P@"; *)
	QUERY:C277([Customers_Invoices:88];  & ; [Customers_Invoices:88]Invoice_Date:7>!2020-01-01!)
	SELECTION TO ARRAY:C260([Customers_Invoices:88]InvoiceNumber:1; $_InvoiceNumber; [Customers_Invoices:88]Invoice_Date:7; $_Invoice_Date; [Customers_Invoices:88]InvType:13; $_InvType)
	
	//start with the column headings
	$csvToExport:="Invoice"+$fieldDelimitor+"Date"+$fieldDelimitor+"Type"+$recordDelimitor
	
	For ($i; 1; Size of array:C274($_InvoiceNumber))
		$csvToExport:=$csvToExport+txt_ToCSV(->$_InvoiceNumber{$i})+$fieldDelimitor\
			+txt_ToCSV(->$_Invoice_Date{$i})+$fieldDelimitor\
			+txt_ToCSV(->$_InvType{$i})+$recordDelimitor
	End for 
	
Else   // Added by: Mel Bohince (6/24/20) sample using collections to join columns and rows
	$es:=ds:C1482.Customers_Invoices.query("InvType = :1  and Invoice_Date > :2"; "debit"; !2021-05-01!).orderBy("InvoiceNumber").orderBy("BillTo")
	C_COLLECTION:C1488($rows_c; $columns_c)
	$rows_c:=New collection:C1472  //there will be a row for each invoice 
	//start with the column headings
	$columns_c:=New collection:C1472
	$columns_c.push("Invoice")
	$columns_c.push("Date")
	$columns_c.push("Customer")
	$columns_c.push("Billto")
	$columns_c.push("InvTerms")
	$columns_c.push("OrdTerms")
	$columns_c.push("CusTerms")
	$rows_c.push($columns_c.join($fieldDelimitor))  //add the headers
	
	For each ($entity; $es)
		
		$columns_c:=New collection:C1472  //set up for the next row of date
		
		$columns_c.push(txt_ToCSV_attribute($entity; "InvoiceNumber"))
		$columns_c.push(txt_ToCSV_attribute($entity; "Invoice_Date"))
		$columns_c.push(CUST_getName($entity.CustomerID; "elc"))
		$columns_c.push(txt_ToCSV_attribute($entity; "BillTo"))
		$columns_c.push(txt_ToCSV_attribute($entity; "Terms"))
		$terms:=""
		$terms:=$entity.ORDER_LINE.ORDER.Terms
		$columns_c.push(txt_ToCSV(->$terms))
		$terms:=$entity.CUSTOMER.Std_Terms
		$columns_c.push(txt_ToCSV(->$terms))
		
		$rows_c.push($columns_c.join($fieldDelimitor))  //add this row
		
	End for each 
	
	$csvToExport:=$rows_c.join($recordDelimitor)  //prep the text to send to file
	
End if   //which techniqe

//save the text to a document
util_SaveTextToDocument("CSV_"; ->$csvToExport)

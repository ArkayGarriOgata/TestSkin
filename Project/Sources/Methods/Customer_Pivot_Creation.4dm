//%attributes = {}
// _______
// Method: Customer_Pivot_Creation ( entity selection ) -> collection of customers by month
// By: Mel Bohince @ 11/29/21, 16:24:44
// Description
// Prepare a grid with 12 month columns plus a total column and 
//   rows for each customer with an entitySelection in a given date
//   range within one contiguous year
//   tested with Customers_Order_Lines, should work with 
//   Customer_Invoices, Customers_ReleaseSchedule, etc
// ----------------------------------------------------
// Modified by: Mel Bohince (12/17/21) add sales rep

C_OBJECT:C1216($pivotSourceTable_es; $1)
C_TEXT:C284($rowsField; $2)  //this will be the key field for each row in the pivot
C_COLLECTION:C1488($customers_c; $grid_c; $0)

$pivotSourceTable_es:=$1
If (Count parameters:C259>1)
	$rowsField:=$2  //invoices for instance use CustomerID as the field name
Else 
	$rowsField:="CustID"
End if 

$customers_c:=$pivotSourceTable_es.distinct($rowsField)  //this collection defines the rows that will be included

$grid_c:=New collection:C1472
$0:=New collection:C1472

C_TEXT:C284($id)
C_TEXT:C284($salesmanID; $salesCoord; $plannerID)

For each ($id; $customers_c)
	$salesmanID:=""  //this we want
	$salesCoord:=""  //needed for call
	$plannerID:=""  //needed for call
	Cust_getTeam($id; ->$salesmanID; ->$salesCoord; ->$plannerID)
	
	$grid_c.push(New object:C1471("salesRep"; $salesmanID; "id"; $id; "name"; CUST_getName($id; "elc"); "01"; 0; "02"; 0; "03"; 0; "04"; 0; "05"; 0; "06"; 0; "07"; 0; "08"; 0; "09"; 0; "10"; 0; "11"; 0; "12"; 0; "total"; 0; "pv"; 0; "avg_unit"; 0; "pctOfBkg"; 0; "pctOfQty"; 0))
End for each 

$0:=$grid_c.orderBy("name")

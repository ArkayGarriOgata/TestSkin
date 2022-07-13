//%attributes = {}
// _______
// Method: Customer_Pivot_Population   ( $pivotSourceTable_es;$grid_c;attribute) ->
// By: Mel Bohince @ 11/29/21, 20:21:43
// Description
// Given a grid collection created by Customer_Pivot_Creation( ),
//    tally the desired attribute (Price_Extended | Cost_Extended |Quantity |etc)
//    for the given entity selection of order lines
// ----------------------------------------------------


C_OBJECT:C1216($1; $pivotSourceTable_es; $entity_e; $arg_o)
$arg_o:=$1  //object containing the es to tally, and the pivots to populate using a specific attribute

$pivotSourceTable_es:=$arg_o.entitySelection

C_COLLECTION:C1488($pivots_c)
$pivots_c:=$arg_o.gridCollections  //this is a collection of grid and attributes to fill

C_LONGINT:C283($row; $column)

For each ($entity_e; $pivotSourceTable_es)
	
	For each ($grid_c; $pivots_c)
		//find the position in the grid row based on index of the customer id
		$row:=$grid_c.collection.indices("id = :1"; $entity_e.CustID)[0]  //get the first element of the returned collection of the requested custid
		//use the month number to find which column to cumulate
		$column:=Month of:C24($entity_e.DateOpened)
		//what value should be accumulated?
		$wantedAttribute:=$grid_c.attribute
		
		//accumulate to cell(row&column)
		$grid_c.collection[$row][String:C10($column; "00")]:=$grid_c.collection[$row][String:C10($column; "00")]+$entity_e[$wantedAttribute]  //.Price_Extended
		//add to the total column once we're here
		$grid_c.collection[$row]["total"]:=$grid_c.collection[$row]["total"]+$entity_e[$wantedAttribute]
		
	End for each   //pivots
	
End for each 

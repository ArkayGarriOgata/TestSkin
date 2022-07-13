//%attributes = {}
// _______
// Method: Customer_Pivot_Totals   (gridCollection {;id_Name}) -> 
// By: Mel Bohince @ 11/29/21, 20:33:02
// Description
// return the column totals as object
// ----------------------------------------------------
C_COLLECTION:C1488($grid_c; $1; $columnTotals_c)
$grid_c:=$1

C_TEXT:C284($2; $id)  //used for the return objects id attribute
If (Count parameters:C259=2)
	$id:=$2
Else 
	$id:=""
End if 

$columnTotals_c:=New collection:C1472
$columnTotals_c.resize(12; 0)

C_OBJECT:C1216($cust_o)  //will contains the customer id, name, and mthly totals
For each ($cust_o; $grid_c)
	
	For ($mth; 0; 11)  //tally the months into cumulative column collection
		$columnTotals_c[$mth]:=$columnTotals_c[$mth]+$cust_o[String:C10($mth+1; "00")]
	End for 
	
End for each 


C_OBJECT:C1216($footer_o; $0)

$footer_o:=New object:C1471("id"; $id; "name"; "TOTALS:")

C_REAL:C285($rowTotal)
$rowTotal:=0

For ($mth; 1; 12)
	$footer_o[String:C10($mth; "00")]:=$columnTotals_c[$mth-1]
	$rowTotal:=$rowTotal+$columnTotals_c[$mth-1]
End for 

$footer_o.total:=$rowTotal

$0:=$footer_o

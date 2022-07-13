//%attributes = {}
// _______
// Method: RIM_ReconcileQtyProblems   ( ) ->
// By: Mel Bohince @ 09/24/19, 14:35:35
// Description
// refactor scripts
// ----------------------------------------------------
// Modified by: Mel Bohince (11/14/21) replace join from pk_id's with POitemkey; this can be a m:n relation
//     & add a tolerance


C_LONGINT:C283($0; $tolerance; $1; $toleranceHigh; $toleranceLow; $i; $numElements)

If (Count parameters:C259>0)
	$tolerance:=$1
	
Else 
	$tolerance:=Num:C11(Request:C163("+/- how many linear feet"; "2000"; "Ok"; "Cancel"))
	If (ok=0)
		$tolerance:=0
	End if 
	
End if 

//Consolidate label qty by po
//ALL RECORDS([Raw_Material_Labels])
QUERY:C277([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Qty:8>0)
SELECTION TO ARRAY:C260([Raw_Material_Labels:171]POItemKey:3; $_POItemKey; [Raw_Material_Labels:171]Qty:8; $_qty)
SORT ARRAY:C229($_POItemKey; $_qty; >)

//get total label qty for each po
ARRAY TEXT:C222($_labelTtlPOItemKey; 0)
ARRAY LONGINT:C221($_labelTtlQty; 0)
$numElements:=Size of array:C274($_POItemKey)
uThermoInit($numElements; "Subtotalling Label PO's")
For ($i; 1; $numElements)
	$hit:=Find in array:C230($_labelTtlPOItemKey; $_POItemKey{$i})
	If ($hit=-1)
		APPEND TO ARRAY:C911($_labelTtlPOItemKey; $_POItemKey{$i})
		APPEND TO ARRAY:C911($_labelTtlQty; $_qty{$i})
	Else 
		$_labelTtlQty{$hit}:=$_labelTtlQty{$hit}+$_qty{$i}
	End if 
	
	uThermoUpdate($i)
End for 
uThermoClose

//now use the po's with label id to get the location records
QUERY WITH ARRAY:C644([Raw_Materials_Locations:25]POItemKey:19; $_labelTtlPOItemKey)

//and in the same fashion consolidate the qty's as it could be in two different warehouses
SELECTION TO ARRAY:C260([Raw_Materials_Locations:25]POItemKey:19; $_POItemKey; [Raw_Materials_Locations:25]QtyOH:9; $_qty_r)

//get total label qty for each po
ARRAY TEXT:C222($_locationTtlPOItemKey; 0)
ARRAY LONGINT:C221($_locationTtlQty; 0)
$numElements:=Size of array:C274($_POItemKey)
uThermoInit($numElements; "Subtotalling Location PO's")
For ($i; 1; $numElements)
	$hit:=Find in array:C230($_locationTtlPOItemKey; $_POItemKey{$i})
	If ($hit=-1)
		APPEND TO ARRAY:C911($_locationTtlPOItemKey; $_POItemKey{$i})
		APPEND TO ARRAY:C911($_locationTtlQty; $_qty_r{$i})
	Else 
		$_locationTtlQty{$hit}:=$_locationTtlQty{$hit}+$_qty_r{$i}
	End if 
	
	uThermoUpdate($i)
End for 
uThermoClose

//now compare the qty from the locations to the qty of the labels, 
//and keep track of the po's that don't match

ARRAY TEXT:C222($_problemPOs; 0)
$numElements:=Size of array:C274($_labelTtlPOItemKey)
uThermoInit($numElements; "Comparing Locations to Labels")
For ($i; 1; $numElements)
	$hit:=Find in array:C230($_locationTtlPOItemKey; $_labelTtlPOItemKey{$i})
	If ($hit>-1)
		$toleranceLow:=$_labelTtlQty{$i}-$tolerance
		$toleranceHigh:=$_labelTtlQty{$i}+$tolerance
		//If ($_locationTtlQty{$hit}#$_labelTtlQty{$i})
		If ($_locationTtlQty{$hit}>$toleranceHigh) | ($_locationTtlQty{$hit}<$toleranceLow)
			APPEND TO ARRAY:C911($_problemPOs; $_locationTtlPOItemKey{$hit})
		End if 
	End if 
	
	uThermoUpdate($i)
End for 
uThermoClose

QUERY WITH ARRAY:C644([Raw_Materials_Locations:25]POItemKey:19; $_problemPOs)
ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1; >)

REDUCE SELECTION:C351([Raw_Material_Labels:171]; 0)  //start with no labels showing

$0:=Size of array:C274($_problemPOs)

//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/12/07, 16:11:00
// ----------------------------------------------------
// Method: BOL_TallyShipment()  --> 
// Description
// calc bottom totals
// ----------------------------------------------------
C_LONGINT:C283($TotalWeight; $Qty; $Cases; $i)

$TotalWeight:=0
$Qty:=0
$Cases:=0

For ($i; 1; Size of array:C274(aReleases))
	$TotalWeight:=$TotalWeight+aWgt2{$i}
	$Qty:=$Qty+aTotalPicked2{$i}
	$Cases:=$Cases+aNumCases2{$i}
End for 
$TotalWeight:=$TotalWeight+(iSkidWeight*[Customers_Bills_of_Lading:49]Total_Skids:17)
[Customers_Bills_of_Lading:49]Total_Wgt:18:=$TotalWeight
[Customers_Bills_of_Lading:49]Total_Cases:14:=$Cases
[Customers_Bills_of_Lading:49]Total_Cartons:12:=$Qty
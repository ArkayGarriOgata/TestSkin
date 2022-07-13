//%attributes = {}

// Method: Rama_NewAP ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 09/17/14, 15:54:39
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------
If (Count parameters:C259=0)
	dBegin:=!2014-07-01!
	dend:=!2014-07-31!
End if 

//Get shipments to customer
QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=dBegin; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=dend; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9="customer"; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]viaLocation:11="@rama@")
DISTINCT VALUES:C339([Finished_Goods_Transactions:33]ProductCode:1; $aShipped)

//Get shipments to rama
QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=dBegin; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=dend; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9="@rama@"; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]viaLocation:11="FG:R@")
DISTINCT VALUES:C339([Finished_Goods_Transactions:33]ProductCode:1; $aMoved)

C_LONGINT:C283($i; $numElements)

$numElements:=Size of array:C274($aShipped)
$candidates:=0
uThermoInit($numElements; "Processing Array")
For ($i; 1; $numElements)
	$hit:=Find in array:C230($aMoved; $aShipped{$i})
	If ($hit>-1)
		$candidates:=$candidates+1
	End if 
	uThermoUpdate($i)
End for 
uThermoClose

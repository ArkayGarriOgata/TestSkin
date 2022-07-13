/*
Entity Class for Job_Form_Items
By: MelvinBohince @ 06/10/22, 10:43:38
Description
           functions to calculate attributes
Example:
     $jobit_e:=ds.Job_Forms_Items.query("Jobit = :1"; "18145.01.05").first()  //"17329.04.06"
     $good:=$jobit_e.quantityGood()
*/

Class extends Entity

Function quantityGood()->$goodQty : Integer
	
	$goodQty:=This:C1470.FG_TRANSACTIONS.getGoodQuantity()
	
	
Function quantityShipped()->$shippedQty : Integer
	
	
	$shippedQty:=This:C1470.FG_TRANSACTIONS.getShippedNetQuantity()
	
Function quantityAvailable()->$availableQty : Integer
	
	$availableQty:=This:C1470.FG_LOCATIONS.getAvailableToShip()
	
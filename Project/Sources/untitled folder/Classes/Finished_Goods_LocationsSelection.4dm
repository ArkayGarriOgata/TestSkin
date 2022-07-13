/*
EntitySelection Class for Finished_Goods_Locations
By: MelvinBohince @ 06/10/22, 09:31:42
Description:
          functions to apply against an fgl entity selection
*/

Class extends EntitySelection

Function getAvailableToShip()->$availableQty : Integer
	
	var $excludeLocations_c : Collection
	
	$excludeLocations_c:=New collection:C1472("@ship@"; "@lost@"; "@kill@"; "@hold@")
	
	$availableQty:=This:C1470.query("Location = :1 AND NOT(Location IN :2)"; "FG@"; $excludeLocations_c).sum("QtyOH")
	
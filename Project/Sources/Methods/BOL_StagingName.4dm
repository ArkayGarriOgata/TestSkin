//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/13/07, 14:55:27
// ----------------------------------------------------
// Method: BOL_StagingName()  --> 
// Description
// common place to create new location name
// ----------------------------------------------------
//see trigger_FinishedGoodsLocations the PREFIX HAS TO MATCH
// ----------------------------------------------------

C_TEXT:C284($0)

If ([Customers_Bills_of_Lading:49]ShippedFrom:5="2")
	$0:="#BL"+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)
Else 
	$0:="#BL"+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)
End if 
//%attributes = {}
// Method: RM_Cold_Foil ( msg ; "find element" )  -> longint (element number)
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 10/25/13, 16:26:33
// ----------------------------------------------------
// Description
// Mgmt of cold foil materials
// ----------------------------------------------------

C_LONGINT:C283($0)
C_TEXT:C284($msg; $1; $2)

$msg:=$1

Case of 
	: ($msg="init")
		ARRAY TEXT:C222(aRMcode; 0)
		RM_ColdFoilQuery  // Added by: Mark Zinke (1/23/14) Replaced query below.
		//QUERY([Raw_Materials];[Raw_Materials]CommodityCode=9)  //cold foils
		SELECTION TO ARRAY:C260([Raw_Materials:21]Raw_Matl_Code:1; aRMcode)
		$0:=Size of array:C274(aRMcode)
		
	: ($msg="find")
		$0:=Find in array:C230(aRMcode; $2)
		
End case 
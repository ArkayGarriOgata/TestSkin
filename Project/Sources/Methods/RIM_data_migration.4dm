//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 03/15/18, 11:47:51
// ----------------------------------------------------
// Method: RIM_data_migration
// Description
// move data from [Raw_Materials_Tappi_Roll_id] to [Raw_Material_Labels]
//
// Parameters
// ----------------------------------------------------

//C_TEXT(sPOI;tRoll_id)
//C_OBJECT(json_obj)


//While (Not(End selection([Raw_Materials_Tappi_Roll_id])))

//ARRAY TEXT(aText;0)
//$poi:=[Raw_Materials_Tappi_Roll_id]POItemKey

//json_obj:=JSON Parse([Raw_Materials_Tappi_Roll_id]Roll_id)
//ARRAY OBJECT($aRollobj;0)
//OB GET ARRAY(json_obj;"rolls";$aRollobj)

//For ($i;1;Size of array($aRollobj))
//APPEND TO ARRAY(aText;OB Get($aRollobj{$i};"roll";Is text))
//End for 

//For ($i;1;Size of array(aText))
//If (Length(aText{$i})>4) & (Length([Raw_Materials_Tappi_Roll_id]POItemKey)>0)
//CREATE RECORD([Raw_Material_Labels])
//[Raw_Material_Labels]Location:="existing"
//[Raw_Material_Labels]POItemKey:=[Raw_Materials_Tappi_Roll_id]POItemKey
//[Raw_Material_Labels]Qty:=[Raw_Materials_Tappi_Roll_id]Linear_Feet

//QUERY([Purchase_Orders_Items];[Purchase_Orders_Items]POItemKey=$poi)
//[Raw_Material_Labels]Raw_Matl_Code:=[Purchase_Orders_Items]Raw_Matl_Code

//SAVE RECORD([Raw_Material_Labels])
//  //see trigger_RM_Labels
//[Raw_Material_Labels]Label_id:=aText{$i}
//[Raw_Material_Labels]Label_id_encoded:=BarCode_128auto ([Raw_Material_Labels]Label_id)
//SAVE RECORD([Raw_Material_Labels])
//End if 
//End for 

//[Raw_Materials_Tappi_Roll_id]Linear_Feet:=Size of array(aText)
//SAVE RECORD([Raw_Materials_Tappi_Roll_id])

//NEXT RECORD([Raw_Materials_Tappi_Roll_id])
//End while 

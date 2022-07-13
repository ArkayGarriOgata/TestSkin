//%attributes = {}
// _______
// Method: RIM_ReconcileQtyAll   ( ) ->
// By: Mel Bohince @ 04/15/19, 15:54:54
// Description
// join locations to labels on foreign key
// ----------------------------------------------------
// Modified by: Mel Bohince (11/15/21) join locations to labels on poitem, 
//   since now the poitem can be in the plant or warehouse

//only look at labels with a positive qty, zero or negative should be manually removed
QUERY:C277([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Qty:8>0)
ORDER BY:C49([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Label_id:2; >)

//get the location records into an arrray
//RELATE ONE SELECTION([Raw_Material_Labels];[Raw_Materials_Locations])
SELECTION TO ARRAY:C260([Raw_Material_Labels:171]POItemKey:3; $_POItemKey)  // Modified by: Mel Bohince (11/13/21) 
QUERY WITH ARRAY:C644([Raw_Materials_Locations:25]POItemKey:19; $_POItemKey)

ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1; >; [Raw_Materials_Locations:25]POItemKey:19; >)


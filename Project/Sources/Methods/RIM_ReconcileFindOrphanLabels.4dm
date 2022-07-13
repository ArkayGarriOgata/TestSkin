//%attributes = {}
// _______
// Method: RIM_ReconcileFindOrphanLabels ( ) ->
// By: Mel Bohince @ 09/24/19, 14:42:30
// Description
// sometimes we have labels but no corrisponding location record, show those labels using Set Difference
// ----------------------------------------------------
// Modified by: Mel Bohince (11/14/21) replace join from pk_id's with POitemkey

//start with all labels to project into Locations
QUERY:C277([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Qty:8>0)

CREATE SET:C116([Raw_Material_Labels:171]; "all_labels")

//get the related locations
//was RELATE ONE SELECTION([Raw_Material_Labels];[Raw_Materials_Locations])
SELECTION TO ARRAY:C260([Raw_Material_Labels:171]POItemKey:3; $_POItemKey)  // Modified by: Mel Bohince (11/13/21) 
QUERY WITH ARRAY:C644([Raw_Materials_Locations:25]POItemKey:19; $_POItemKey)
ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1; >)


//now project that back on the labels
//was RELATE MANY SELECTION([Raw_Material_Labels]RM_Location_fk)
SELECTION TO ARRAY:C260([Raw_Materials_Locations:25]POItemKey:19; $_POItemKey)  // Modified by: Mel Bohince (11/13/21) 
QUERY WITH ARRAY:C644([Raw_Material_Labels:171]POItemKey:3; $_POItemKey)

CREATE SET:C116([Raw_Material_Labels:171]; "have_location_rec")

DIFFERENCE:C122("all_labels"; "have_location_rec"; "missing_location_rec")

USE SET:C118("missing_location_rec")
ORDER BY:C49([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Label_id:2; >)

CLEAR SET:C117("missing_location_rec")
CLEAR SET:C117("have_location_rec")
CLEAR SET:C117("all_labels")

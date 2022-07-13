//QUERY([RM_BINS];[RM_BINS]Raw_Matl_Code=[RM_Components]Compnt_Raw_Matl)

//If (Records in selection([RM_BINS])>0)

//ORDER BY([RM_BINS];[RM_BINS]POItemKey;>)

//[RM_Components]Bin_Location:=[RM_BINS]Location

//[RM_Components]PO_Item:=[RM_BINS]POItemKey

//[RM_Components]UnitCost:=[RM_BINS]ActCost

//Else 

//QUERY([PO_Items];[PO_Items]Raw_Matl_Code=[RM_Components]Compnt_Raw_Matl)

//If (Records in selection([PO_Items])>0)

//ORDER BY([PO_Items];[PO_Items]POItemKey;<)

//  `[RM_Components]PO_Item:=[PO_Items]POItemKey

//[RM_Components]UnitCost:=[PO_Items]UnitPrice

//End if 

//End if 

//
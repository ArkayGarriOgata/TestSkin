//%attributes = {"publishedWeb":true}
//gRMBinsDel: Deletion for file [RM_BINS]

If ([Raw_Materials_Locations:25]QtyOH:9>0)
	ALERT:C41("Quantity on hand must be zero to delete this record.")
Else 
	gDeleteRecord(->[Raw_Materials_Locations:25])
	//RELATE MANY([Raw_Materials]Raw_Matl_Code)
End if 
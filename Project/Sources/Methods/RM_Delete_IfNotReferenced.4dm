//%attributes = {"publishedWeb":true}
//gRawMatDel: Deletion for file [RAW_MATERIALS]
//10/25/94

QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=[Raw_Materials:21]Raw_Matl_Code:1)
If (Sum:C1([Raw_Materials_Locations:25]QtyOH:9)>0) | (Sum:C1([Raw_Materials_Locations:25]ConsignmentQty:26)>0)
	ALERT:C41("Raw Mat has inventory onhand or consigned. Must zero out the quantity.")
Else 
	//QUERY([Material_Est];[Material_Est]Raw_Matl_Code=[RAW_MATERIALS]Raw_Matl_Code)
	//If (Records in selection([Material_Est])>0)
	//ALERT("R/M is listed in an Estimate record. Estimate Material record must be 
	//«deleted.")
	//Else 
	
	//QUERY([Material_Job];[Material_Job]Raw_Matl_Code=[RAW_MATERIALS]Raw_Matl_Code)
	//If (Records in selection([Material_Job])>0)
	//ALERT("Raw Material is listed in an job record. Job Material record must be 
	//«deleted")
	//Else 
	
	QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]Raw_Matl_Code:1=[Raw_Materials:21]Raw_Matl_Code:1)
	If (Records in selection:C76([Raw_Materials_Allocations:58])>0)
		ALERT:C41("R/M has allocation records.  Allocations must be deleted.")
	Else 
		QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]Raw_Matl_Code:15=[Raw_Materials:21]Raw_Matl_Code:1; *)
		QUERY:C277([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]Qty_Open:27>0)
		If (Records in selection:C76([Purchase_Orders_Items:12])>0)
			ALERT:C41("R/M is on order.  Purchase Order must be deleted.")
		Else 
			
			gDeleteRecord(->[Raw_Materials:21])
			If ((fDelete) & (Not:C34(fCnclTrn)))
				DELETE SELECTION:C66([Raw_Materials_Locations:25])
				QUERY:C277([Raw_Materials_Components:60]; [Raw_Materials_Components:60]Parent_Raw_Matl:1=[Raw_Materials:21]Raw_Matl_Code:1)
				DELETE SELECTION:C66([Raw_Materials_Components:60])
			End if 
			
		End if 
	End if 
End if 
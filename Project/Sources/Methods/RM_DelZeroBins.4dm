//%attributes = {"publishedWeb":true}
//gDelZeroRMBins
//delete those RM bins which have zero items
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]QtyOH:9>-1; *)
	QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]QtyOH:9<1)  //use range to catch representation errors
	// • mel (3/29/04, 16:04:07) `don't delete consignments.
	
	QUERY SELECTION:C341([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]ConsignmentQty:26=0)
	
Else 
	
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]QtyOH:9>-1; *)
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]QtyOH:9<1; *)
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]ConsignmentQty:26=0)
	
End if   // END 4D Professional Services : January 2019 query selection


utl_LogfileServer(<>zResp; "[Raw_Materials_Locations] Deletin zero bins, "+String:C10(Records in selection:C76([Raw_Materials_Locations:25]))+" records"; "PhyInv.log")

util_DeleteSelection(->[Raw_Materials_Locations:25])
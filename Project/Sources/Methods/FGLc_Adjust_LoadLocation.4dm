//%attributes = {}
//Method:  FGLc_Adjust_LoadLocation (tPk_ID)
//Description:  This method 

If (True:C214)  //Initialize 
	
	C_TEXT:C284($1; $tPk_ID)
	
	$tPk_ID:=$1
	
End if   //Done Initialize

If (Core_Query_UniqueRecordB(->[Finished_Goods_Locations:35]pk_id:45; ->$tPk_ID))
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=[Finished_Goods_Locations:35]Jobit:33)
	
	Compiler_FGLc_Array(Current method name:C684; 0)
	
	SELECTION TO ARRAY:C260(\
		[Finished_Goods_Locations:35]Jobit:33; FGLc_atLoc_JobIT; \
		[Finished_Goods_Locations:35]Location:2; FGLc_atLoc_Location; \
		[Finished_Goods_Locations:35]skid_number:43; FGLc_atLoc_Skid; \
		[Finished_Goods_Locations:35]QtyOH:9; FGLc_anLoc_Qty; \
		[Finished_Goods_Locations:35]pk_id:45; FGLc_atLoc_Pk_id)
	
	COPY ARRAY:C226(FGLc_anLoc_Qty; FGLc_anLoc_OriginalQty)
	
	Compiler_FGLc_Array(Current method name:C684+"1"; Size of array:C274(FGLc_atLoc_JobIT))  //FGLc_abLoc_Delete
	
	SORT ARRAY:C229(FGLc_atLoc_Skid; \
		FGLc_atLoc_JobIT; \
		FGLc_atLoc_Location; \
		FGLc_anLoc_Qty; \
		FGLc_abLoc_Delete; \
		FGLc_anLoc_OriginalQty; \
		FGLc_atLoc_Pk_id; >)
	
End if 

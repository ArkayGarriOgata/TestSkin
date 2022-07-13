//%attributes = {}
//Method:  FGLc_Adjust_Negative(tPhase)
//Description:  This method handles initializing values

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	C_LONGINT:C283($nColumn; $nRow)
	
	$tPhase:=$1
	
End if   //Done Initialize

Case of   //Phase
		
	: ($tPhase=CorektPhaseAssignVariable)
		
		LISTBOX GET CELL POSITION:C971(FGLc_abAdjust_Negative; $nColumn; $nRow)
		
		If (($nRow>0) & ($nRow<=Size of array:C274(FGLc_atNeg_Pk_id)))  //Valid row
			
			$tPk_id:=FGLc_atNeg_Pk_id{$nRow}
			
			FGLc_Adjust_Location(CorektPhaseInitialize; ->$tPk_id)
			
			FGLc_Adjust_LoadTransaction($tPk_id)
			
			FGLc_Adjust_Reason(Current method name:C684)  //Must follow FGLc_Adjust_LoadTransaction
			
			If (Core_Query_UniqueRecordB(->[Finished_Goods_Locations:35]pk_id:45; ->$tPk_id))  //Details
				
				FGLc_tAdjust_JobIt:=[Finished_Goods_Locations:35]Jobit:33
				FGLc_tAdjust_Skid:=[Finished_Goods_Locations:35]skid_number:43
				FGLc_tAdjust_ProductCode:=[Finished_Goods_Locations:35]ProductCode:1
				FGLc_tAdjust_Quantity:=String:C10([Finished_Goods_Locations:35]QtyOH:9)
				
			End if   //Done details
			
		End if   //Done valid row
		
		FGLc_Adjust_Manager
		
	: ($tPhase=CorektPhaseInitialize)
		
		FGLc_Adjust_Negative(CorektPhaseClear)
		
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]QtyOH:9<0)
		
		SELECTION TO ARRAY:C260(\
			[Finished_Goods_Locations:35]ProductCode:1; FGLc_atNeg_ProductCode; \
			[Finished_Goods_Locations:35]QtyOH:9; FGLc_anNeg_Quantity; \
			[Finished_Goods_Locations:35]pk_id:45; FGLc_atNeg_Pk_id)
		
		MULTI SORT ARRAY:C718(FGLc_atNeg_ProductCode; >; FGLc_anNeg_Quantity; >; FGLc_atNeg_Pk_id)
		
		Compiler_FGLc_Array(Current method name:C684+"1"; Size of array:C274(FGLc_atNeg_ProductCode))
		
	: ($tPhase=CorektPhaseClear)
		
		Compiler_FGLc_Array(Current method name:C684; 0)
		
		FGLc_tAdjust_JobIt:=CorektBlank
		FGLc_tAdjust_Skid:=CorektBlank
		FGLc_tAdjust_ProductCode:=CorektBlank
		FGLc_tAdjust_Quantity:=CorektBlank
		
End case   //Done phase
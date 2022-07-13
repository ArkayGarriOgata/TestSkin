//%attributes = {}
//Method:  FGLc_Adjust_LoadTransaction (tPk_ID)
//Description:  This method 

If (True:C214)  //Initialize 
	
	C_TEXT:C284($1; $tPk_ID)
	
	$tPk_ID:=$1
	
End if   //Done Initialize

Case of 
		
	: (Not:C34(Core_Query_UniqueRecordB(->[Finished_Goods_Locations:35]pk_id:45; ->$tPk_ID)))
	: (Not:C34(FGLc_Trans_QueryExistB([Finished_Goods_Locations:35]skid_number:43; [Finished_Goods_Locations:35]ProductCode:1)))
		
	Else 
		
		Compiler_FGLc_Array(Current method name:C684; 0)
		
		SELECTION TO ARRAY:C260(\
			[Finished_Goods_Transactions:33]Jobit:31; FGLc_atTrans_JobIT; \
			[Finished_Goods_Transactions:33]Skid_number:29; FGLc_atTrans_Skid; \
			[Finished_Goods_Transactions:33]viaLocation:11; FGLc_atTrans_From; \
			[Finished_Goods_Transactions:33]Location:9; FGLc_atTrans_To; \
			[Finished_Goods_Transactions:33]Qty:6; FGLc_anTrans_Qty; \
			[Finished_Goods_Transactions:33]XactionType:2; FGLc_atTrans_Type; \
			[Finished_Goods_Transactions:33]transactionDateTime:40; FGLc_atTrans_DateTime; \
			[Finished_Goods_Transactions:33]pk_id:37; FGLc_atTrans_Pk_id)
		
		Compiler_FGLc_Array(Current method name:C684+"1"; Size of array:C274(FGLc_atTrans_DateTime))
		
		SORT ARRAY:C229(FGLc_atTrans_DateTime; \
			FGLc_atTrans_JobIT; \
			FGLc_atTrans_Skid; \
			FGLc_atTrans_From; \
			FGLc_atTrans_To; \
			FGLc_anTrans_Qty; \
			FGLc_atTrans_Type; \
			FGLc_atTrans_DateTime; \
			FGLc_atTrans_Pk_id; >)
		
End case 






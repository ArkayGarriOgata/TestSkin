//%attributes = {"publishedWeb":true}
//PM:  FG_QAs_Records()  2/15/01  mlb
//set up QAs if required

If (Count parameters:C259=1)  //as of 8/7/01 feature not used so stop creating.
	RELATE MANY:C262([Finished_Goods_Specifications:98]QA_Records:52)
	If (Records in selection:C76([Finished_Goods_Spec_QA_Records:189])=0)
		CREATE RECORD:C68([Finished_Goods_Spec_QA_Records:189])
		[Finished_Goods_Spec_QA_Records:189]id_added_by_converter:5:=[Finished_Goods_Specifications:98]QA_Records:52
		[Finished_Goods_Spec_QA_Records:189]Item:1:="Size & Style"
		SAVE RECORD:C53([Finished_Goods_Spec_QA_Records:189])
		
		CREATE RECORD:C68([Finished_Goods_Spec_QA_Records:189])
		[Finished_Goods_Spec_QA_Records:189]id_added_by_converter:5:=[Finished_Goods_Specifications:98]QA_Records:52
		[Finished_Goods_Spec_QA_Records:189]Item:1:="Dylux"
		SAVE RECORD:C53([Finished_Goods_Spec_QA_Records:189])
		
		CREATE RECORD:C68([Finished_Goods_Spec_QA_Records:189])
		[Finished_Goods_Spec_QA_Records:189]id_added_by_converter:5:=[Finished_Goods_Specifications:98]QA_Records:52
		[Finished_Goods_Spec_QA_Records:189]Item:1:="Color Print"
		SAVE RECORD:C53([Finished_Goods_Spec_QA_Records:189])
		
		CREATE RECORD:C68([Finished_Goods_Spec_QA_Records:189])
		[Finished_Goods_Spec_QA_Records:189]id_added_by_converter:5:=[Finished_Goods_Specifications:98]QA_Records:52
		[Finished_Goods_Spec_QA_Records:189]Item:1:="Matchprint"
		SAVE RECORD:C53([Finished_Goods_Spec_QA_Records:189])
		
		CREATE RECORD:C68([Finished_Goods_Spec_QA_Records:189])
		[Finished_Goods_Spec_QA_Records:189]id_added_by_converter:5:=[Finished_Goods_Specifications:98]QA_Records:52
		[Finished_Goods_Spec_QA_Records:189]Item:1:="Color Tolerance"
		SAVE RECORD:C53([Finished_Goods_Spec_QA_Records:189])
		
		CREATE RECORD:C68([Finished_Goods_Spec_QA_Records:189])
		[Finished_Goods_Spec_QA_Records:189]id_added_by_converter:5:=[Finished_Goods_Specifications:98]QA_Records:52
		[Finished_Goods_Spec_QA_Records:189]Item:1:="Drawdown"
		SAVE RECORD:C53([Finished_Goods_Spec_QA_Records:189])
		
		CREATE RECORD:C68([Finished_Goods_Spec_QA_Records:189])
		[Finished_Goods_Spec_QA_Records:189]id_added_by_converter:5:=[Finished_Goods_Specifications:98]QA_Records:52
		[Finished_Goods_Spec_QA_Records:189]Item:1:="Customer Match Medium"
		SAVE RECORD:C53([Finished_Goods_Spec_QA_Records:189])
		
		RELATE MANY:C262([Finished_Goods_Specifications:98]QA_Records:52)
	End if 
End if 
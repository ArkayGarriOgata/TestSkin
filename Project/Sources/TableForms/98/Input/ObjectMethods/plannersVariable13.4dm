//-JML   9/29/93
//have to allow user to choose from existing pSpec or create a brand new one.
//• 10/8/97 cs track last used date for pSpecs

MESSAGES OFF:C175
$pspec:=Request:C163("Get the Inks from Process Spec:"; ""; "Fetch"; "Cancel")

If (OK=1)
	[Finished_Goods_Specifications:98]CommentsFromPlanner:19:="use inks from pspec: "+$pspec+Char:C90(13)+[Finished_Goods_Specifications:98]CommentsFromPlanner:19
	READ ONLY:C145([Process_Specs:18])
	READ ONLY:C145([Process_Specs_Materials:56])
	READ ONLY:C145([Raw_Materials:21])
	QUERY:C277([Process_Specs:18]; [Process_Specs:18]PSpecKey:106=(Substring:C12([Finished_Goods_Specifications:98]FG_Key:1; 1; 6)+$pspec))
	If (Records in selection:C76([Process_Specs:18])>0)
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			PSpecEstimateLd(""; "Materials")
			QUERY SELECTION:C341([Process_Specs_Materials:56]; [Process_Specs_Materials:56]Commodity_Key:8="02@"; *)
			QUERY SELECTION:C341([Process_Specs_Materials:56];  | ; [Process_Specs_Materials:56]Commodity_Key:8="03@")
			
		Else 
			
			QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]Commodity_Key:8="02@"; *)
			QUERY:C277([Process_Specs_Materials:56];  | ; [Process_Specs_Materials:56]Commodity_Key:8="03@"; *)
			QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]ProcessSpec:1=[Process_Specs:18]ID:1; *)
			QUERY:C277([Process_Specs_Materials:56]; [Process_Specs_Materials:56]CustID:2=[Process_Specs:18]Cust_ID:4)
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		If (Records in selection:C76([Process_Specs_Materials:56])>0)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				ORDER BY:C49([Process_Specs_Materials:56]; [Process_Specs_Materials:56]Real2:15; >)
				FIRST RECORD:C50([Process_Specs_Materials:56])
				
				
			Else 
				
				ORDER BY:C49([Process_Specs_Materials:56]; [Process_Specs_Materials:56]Real2:15; >)
				
			End if   // END 4D Professional Services : January 2019 First record
			
			While (Not:C34(End selection:C36([Process_Specs_Materials:56])))
				CREATE RECORD:C68([Finished_Goods_Specs_Inks:188])
				[Finished_Goods_Specs_Inks:188]id_added_by_converter:7:=[Finished_Goods_Specifications:98]Ink:24
				[Finished_Goods_Specs_Inks:188]ControlNumber:6:=[Finished_Goods_Specifications:98]ControlNumber:2
				[Finished_Goods_Specs_Inks:188]Rotation:1:=[Process_Specs_Materials:56]Real2:15
				[Finished_Goods_Specs_Inks:188]InkNumber:3:=[Process_Specs_Materials:56]Raw_Matl_Code:13
				QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Process_Specs_Materials:56]Raw_Matl_Code:13)
				If (Records in selection:C76([Raw_Materials:21])>0)
					[Finished_Goods_Specs_Inks:188]Color:4:=[Raw_Materials:21]Flex5:23
				Else 
					[Finished_Goods_Specs_Inks:188]Color:4:="n/a"
				End if 
				SAVE RECORD:C53([Finished_Goods_Specs_Inks:188])
				
				NEXT RECORD:C51([Process_Specs_Materials:56])
			End while 
			RELATE MANY:C262([Finished_Goods_Specifications:98]Ink:24)
			ORDER BY:C49([Finished_Goods_Specs_Inks:188]; [Finished_Goods_Specs_Inks:188]Side:2; >; [Finished_Goods_Specs_Inks:188]Rotation:1; >)
			
		Else 
			uConfirm($pspec+" has no inks or coatings"; "OK"; "Help")
		End if 
		
	Else 
		uConfirm($pspec+" not found for this customer"; "OK"; "Help")
	End if 
	REDUCE SELECTION:C351([Process_Specs:18]; 0)
	REDUCE SELECTION:C351([Process_Specs_Materials:56]; 0)
	REDUCE SELECTION:C351([Raw_Materials:21]; 0)
End if 
MESSAGES ON:C181
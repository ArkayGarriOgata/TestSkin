If ([Finished_Goods_Specifications:98]Approved:10)
	READ WRITE:C146([Finished_Goods:26])
	$numFG:=qryFinishedGood(Substring:C12([Finished_Goods_Specifications:98]FG_Key:1; 1; 5); [Finished_Goods_Specifications:98]ProductCode:3)
	[Finished_Goods:26]ControlNumber:61:=[Finished_Goods_Specifications:98]ControlNumber:2
	[Finished_Goods:26]DateArtApproved:46:=4D_Current_date
	SAVE RECORD:C53([Finished_Goods:26])
	REDUCE SELECTION:C351([Finished_Goods:26]; 0)
	
	If ([Finished_Goods_Specifications:98]DatePrepDone:6=!00-00-00!)
		[Finished_Goods_Specifications:98]DatePrepDone:6:=4D_Current_date
	End if 
	If ([Finished_Goods_Specifications:98]DateProofRead:7=!00-00-00!)
		[Finished_Goods_Specifications:98]DateProofRead:7:=4D_Current_date
	End if 
	If ([Finished_Goods_Specifications:98]DateSentToCustomer:8=!00-00-00!)
		[Finished_Goods_Specifications:98]DateSentToCustomer:8:=4D_Current_date
	End if 
	If ([Finished_Goods_Specifications:98]DateReturned:9=!00-00-00!)
		[Finished_Goods_Specifications:98]DateReturned:9:=4D_Current_date
	End if 
End if 
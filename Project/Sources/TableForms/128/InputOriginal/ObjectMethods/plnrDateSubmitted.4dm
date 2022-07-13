If ([Finished_Goods_Color_SpecMaster:128]DateSubmitted:19<=4D_Current_date)  //[ColorSpecMaster]DateReceived
	
	If (4d_Current_time<=?12:00:00?)  // • mel (2/25/04, 12:34:25)
		
		[Finished_Goods_Color_SpecMaster:128]DateSubmitted:19:=4D_Current_date
	Else 
		[Finished_Goods_Color_SpecMaster:128]DateSubmitted:19:=4D_Current_date+1
	End if 
End if 

If ([Finished_Goods_Color_SpecMaster:128]DateSubmitted:19#!00-00-00!)
	Case of   // • mel (2/25/04, 12:34:25)
			
		: (Day number:C114([Finished_Goods_Color_SpecMaster:128]DateSubmitted:19)=7)  //saturday
			
			[Finished_Goods_Color_SpecMaster:128]DateSubmitted:19:=[Finished_Goods_Color_SpecMaster:128]DateSubmitted:19+2
		: (Day number:C114([Finished_Goods_Color_SpecMaster:128]DateSubmitted:19)=1)  //sundaty
			
			[Finished_Goods_Color_SpecMaster:128]DateSubmitted:19:=[Finished_Goods_Color_SpecMaster:128]DateSubmitted:19+1
	End case 
End if 
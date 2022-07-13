If ([Finished_Goods_Color_SpecMaster:128]DateSubmitted:19#!00-00-00!)
	Cal_getDate(->[Finished_Goods_Color_SpecMaster:128]DateSubmitted:19; Month of:C24([Finished_Goods_Color_SpecMaster:128]DateSubmitted:19); Year of:C25([Finished_Goods_Color_SpecMaster:128]DateSubmitted:19))
Else 
	Cal_getDate(->[Finished_Goods_Color_SpecMaster:128]DateSubmitted:19)
End if 


If ([Finished_Goods_Color_SpecMaster:128]DateSubmitted:19<=4D_Current_date)
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
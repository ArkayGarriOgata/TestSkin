If ([Finished_Goods_Color_SpecMaster:128]DateDone:20#!00-00-00!)  //[ColorSpecMaster]DateSubmitted
	
	Cal_getDate(->[Finished_Goods_Color_SpecMaster:128]DateDone:20; Month of:C24([Finished_Goods_Color_SpecMaster:128]DateDone:20); Year of:C25([Finished_Goods_Color_SpecMaster:128]DateDone:20))
Else 
	Cal_getDate(->[Finished_Goods_Color_SpecMaster:128]DateDone:20)
End if 
//


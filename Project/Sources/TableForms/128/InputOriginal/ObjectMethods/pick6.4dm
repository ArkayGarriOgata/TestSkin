If ([Finished_Goods_Color_SpecMaster:128]DateReturned:22#!00-00-00!)
	Cal_getDate(->[Finished_Goods_Color_SpecMaster:128]DateReturned:22; Month of:C24([Finished_Goods_Color_SpecMaster:128]DateReturned:22); Year of:C25([Finished_Goods_Color_SpecMaster:128]DateReturned:22))
Else 
	Cal_getDate(->[Finished_Goods_Color_SpecMaster:128]DateReturned:22)
End if 
//
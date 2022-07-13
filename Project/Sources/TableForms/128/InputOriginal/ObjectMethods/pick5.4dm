If ([Finished_Goods_Color_SpecMaster:128]DateSent:21#!00-00-00!)
	Cal_getDate(->[Finished_Goods_Color_SpecMaster:128]DateSent:21; Month of:C24([Finished_Goods_Color_SpecMaster:128]DateSent:21); Year of:C25([Finished_Goods_Color_SpecMaster:128]DateSent:21))
Else 
	Cal_getDate(->[Finished_Goods_Color_SpecMaster:128]DateSent:21)
End if 
//
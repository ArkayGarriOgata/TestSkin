If ([Finished_Goods_Color_SpecMaster:128]DateApproved:18#!00-00-00!)
	Cal_getDate(->[Finished_Goods_Color_SpecMaster:128]DateApproved:18; Month of:C24([Finished_Goods_Color_SpecMaster:128]DateApproved:18); Year of:C25([Finished_Goods_Color_SpecMaster:128]DateApproved:18))
Else 
	Cal_getDate(->[Finished_Goods_Color_SpecMaster:128]DateApproved:18)
End if 
//
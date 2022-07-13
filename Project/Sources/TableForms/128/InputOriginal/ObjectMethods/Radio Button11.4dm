// ----------------------------------------------------
// Object Method: [Finished_Goods_Color_SpecMaster].Input.Radio Button11
// SetObjectProperties, Mark Zinke (5/16/13)
// ----------------------------------------------------

CSM_setField(->[Finished_Goods_Color_SpecMaster:128]finishType:11; ->cb8; "W/B")
If (Position:C15("None"; [Finished_Goods_Color_SpecMaster:128]finishType:11)=0)
	SetObjectProperties("fininsh@"; -><>NULL; True:C214)
Else 
	SetObjectProperties("fininsh@"; -><>NULL; False:C215)
End if 
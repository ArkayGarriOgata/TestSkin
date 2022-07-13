//(s) Raw_Matl_Code [material_psepc]incl
//• 5/22/97 cs modified
txt_CapNstrip(Self:C308)
RM_doesExist(Self:C308; [Estimates_Materials:29]Commodity_Key:6)

If (Self:C308->#"")
	RM_AllocationChk([Jobs:15]CustID:2)
End if 
//
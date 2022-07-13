//(s) Raw_Matl_Code [material_psepc]incl
//• 5/22/97 cs modified
//• 7/23/98 cs added code to update material estimates &
//possibly material pspecs

RM_doesExist(->[Job_Forms_Materials:55]Raw_Matl_Code:7; [Estimates_Materials:29]Commodity_Key:6)

If ([Job_Forms_Materials:55]Raw_Matl_Code:7#"")
	MatBud2MatEst
	RM_AllocationChk([Jobs:15]CustID:2)
End if 
//
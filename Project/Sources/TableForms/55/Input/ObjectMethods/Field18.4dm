//(s) Raw_Matl_Code [materialjob]input
//• 5/22/97 cs modified
//• 7/23/98 cs added code to update material estimates &
//possibly material pspecs
RM_doesExist(Self:C308; [Job_Forms_Materials:55]Commodity_Key:12; "*")

If (Self:C308->#"")  //if the raw materal code is valid
	MatBud2MatEst
	RM_AllocationChk([Jobs:15]CustID:2)
End if 
//
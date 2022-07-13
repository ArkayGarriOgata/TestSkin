
//[generic];"include"
Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		util_alternateBackground
		
		C_TEXT:C284(tText)
		tText:=""
		tText:=CSM_countColors
		$ok:=CSM_getVerboseStock(->tText)
		tText:=tText+Char:C90(9)
		$ok:=CSM_getVerboseFinish(->tText)
		
End case 

app_SelectIncludedRecords(->[Finished_Goods_Color_SpecMaster:128]id:1)

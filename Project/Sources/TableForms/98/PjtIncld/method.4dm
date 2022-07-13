//[generic];"include"

Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		util_alternateBackground
		
End case 

app_SelectIncludedRecords(->[Finished_Goods_Specifications:98]ControlNumber:2)
